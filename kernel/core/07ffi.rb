module FFI
  
  class TypeError < RuntimeError
  end
  
  TypeDefs = {}
  
  class << self
    
    def add_typedef(current, add)
      if Fixnum === current
        code = current
      else
        code = FFI::TypeDefs[current]
        raise TypeError, "Unable to resolve type '#{current}'" unless code
      end
      
      FFI::TypeDefs[add] = code
    end
    
    def find_type(name)
      code = FFI::TypeDefs[name]
      raise TypeError, "Unable to resolve type '#{name}'" unless name
      return code
    end
    
    def create_backend(library, name, args, ret)
      Ruby.primitive :nfunc_add
    end
    
    def create_function(library, name, args, ret)
      cargs = []
      i = 0
      tot = args.size
      # We use this instead of map or each because it's really early, map
      # isn't yet available.
      while i < tot
        cargs[i] = find_type(args[i])
        i += 1
      end
      cret = find_type(ret)
      
      create_backend(library, name, cargs, cret)
    end
  end  
  
  add_typedef TYPE_OBJECT,  :object
  add_typedef TYPE_CHAR,    :char
  add_typedef TYPE_UCHAR,   :uchar
  add_typedef TYPE_SHORT,   :short
  add_typedef TYPE_USHORT,  :ushort
  add_typedef TYPE_INT,     :int
  add_typedef TYPE_UINT,    :uint
  add_typedef TYPE_LONG,    :long
  add_typedef TYPE_ULONG,   :ulong
  add_typedef TYPE_FLOAT,   :float
  add_typedef TYPE_DOUBLE,  :double
  add_typedef TYPE_PTR,     :pointer
  add_typedef TYPE_VOID,    :void
  add_typedef TYPE_STRING,  :string
  add_typedef TYPE_STATE,   :state
  add_typedef TYPE_STRPTR,  :string_and_pointer
  add_typedef TYPE_STRPTR,  :strptr
  
end

class MemoryPointer
  def inspect
    "#<MemoryPointer address=0x#{address.to_s(16)}>"
  end
  
  def address
    i = get_byte(3)
    i += (get_byte(2) << 8)
    i += (get_byte(1) << 16)
    i += (get_byte(0) << 24)
    return i
  end
end


class Module
  def attach_function(lib, name, a3, a4, a5=nil)
    if a5
      mname = a3
      args = a4
      ret = a5
    else
      mname = name.to_sym
      args = a3
      ret = a4
    end
    
    func = FFI.create_function lib, name, args, ret
    
    raise "Unable to create function #{name}" unless func
    
    metaclass.method_table[mname] = func
    return func
  end
end

module FFI
  attach_function nil, "ffi_type_size", :get_type_size, [:int], :int
  
  def self.type_size(type)
    get_type_size(find_type(type))
  end
  
  class Struct
    
    attach_function nil, "ffi_get_field", [:pointer, :int, :int], :object
    attach_function nil, "ffi_set_field", [:pointer, :int, :int, :object], :void
    
    def self.layout(*spec)
      return @layout if spec.empty?
      
      cspec = {}
      offset = 0
      i = 0
      
      while i < spec.size
        name = spec[i]
        f = spec[i + 1]
        code = FFI.find_type(f)
        cur = offset
        offset += FFI.type_size(f)
        cspec[name] = [cur, code]
        i += 2
      end
      
      if self != Struct
        @layout = cspec
      end
      
      return cspec
    end
    
    def initialize(ptr, *spec)
      @ptr = ptr
      @cspec = self.class.layout()
    end
    
    def [](field)
      offset, type = @cspec[field]
      raise "Unknown field #{field}" unless offset
      
      Struct.ffi_get_field(@ptr, offset, type)
    end
    
    def []=(field, val)
      offset, type = @cspec[field]
      raise "Unknown field #{field}" unless offset
      
      Struct.ffi_set_field(@ptr, offset, type, val)
      return val
    end
  end
  
end

class NativeFunction
  
  # The *args means the primitive handles it own argument count checks.
  def call(*args)
    Ruby.primitive :nfunc_call_object
  end
  
  class Variable
    def initialize(library, name, a2, a3=nil)
      if a3
        @ret = a3
        @static_args = a2
      else
        @ret = a2
        @static_args = nil
      end

      @library = library
      @name = name
      @functions = {}
    end
    
    def find_function(at)
      if @static_args
        at = @static_args + at
      end
      
      if func = @functions[at]
        return func
      end
      
      func = FFI.create_function @library, @name, at, @ret
      @functions[at] = func
      return func
    end
    
    def [](*args)
      find_function(args)
    end
        
    def call(at, *args)
      find_function(at).call(*args)
    end
  end
end
