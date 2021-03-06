require 'benchmark'
require 'benchmark/ips'

# these are all different ways of removing the first element from
# an array until it is empty

random_elements = [4887, 4310, 4656, 254, 3258, 867, 3751, 516, 2240, 1678, 3027, 1911, 2875, 3872, 4469, 2263, 3721, 948, 2939, 4323, 4513, 4118, 930, 1178, 3749, 4446, 2075, 1240, 1703, 1412, 1309, 4426, 350, 4973, 2254, 1189, 2645, 695, 4518, 2157, 451, 2581, 2941, 901, 2634, 2243, 2872, 4487, 3467, 2425, 138, 929, 3882, 2469, 4972, 2121, 2809, 1733, 827, 2666, 3746, 4572, 4799, 297, 2682, 3254, 4768, 1115, 365, 1927, 2824, 1169, 1812, 4211, 411, 4203, 2369, 4004, 216, 4186, 1475, 642, 4794, 3624, 2108, 807, 3052, 4610, 581, 1451, 4570, 2312, 4361, 400, 3770, 3976, 902, 1108, 310, 1444, 605, 22, 3685, 874, 1431, 3318, 4732, 637, 3575, 440, 1543, 1869, 449, 2811, 2716, 3776, 2050, 1483, 616, 3317, 4240, 3200, 3004, 4406, 2228, 2512, 106, 751, 2012, 3581, 3481, 2519, 651, 2622, 4051, 1492, 4932, 2281, 1308, 3060, 4061, 2549, 1853, 1177, 3995, 1948, 2877, 763, 1780, 2579, 4543, 4473, 3127, 265, 3561, 1261, 2049, 640, 2703, 1468, 3980, 3635, 3478, 566, 3432, 335, 341, 855, 4891, 2478, 4168, 3012, 932, 4402, 1562, 1230, 831, 3973, 2260, 3660, 3713, 1022, 4081, 1909, 2138, 2820, 155, 4535, 3742, 4683, 4097, 707, 2794, 3122, 271, 668, 2006, 4958, 1387, 3550, 2160, 1832, 3558, 2230, 178, 2214, 2247, 2040, 2962, 3885, 924, 590, 489, 3289, 199, 2740, 724, 3824, 4903, 671, 2355, 4032, 1880, 2798, 1720, 580, 12, 48, 1458, 1878, 602, 3132, 1648, 2131, 488, 4754, 1654, 1339, 1601, 1825, 4356, 3335, 3517, 1378, 4773, 3114, 3787, 3383, 2891, 1367, 1692, 3886, 4664, 4654, 3817, 3965, 1369, 2869, 4521, 2097, 1569, 3082, 90, 4478, 3617, 662, 3206, 2361, 3223, 3907, 931, 4252, 3473, 1150, 3648, 3878, 188, 4183, 4025, 3185, 501, 288, 3163, 469, 4042, 4233, 2175, 401, 4113, 2680, 4686, 1055, 622, 2442, 958, 825, 1762, 1755, 937, 1090, 2593, 3167, 862, 986, 1152, 4303, 1194, 3953, 366, 4189, 3380, 2925, 752, 4802, 3419, 1756, 3418, 302, 3344, 775, 1768, 4939, 1235, 266, 4947, 1326, 4209, 4459, 4441, 284, 1580, 2200, 2814, 926, 2048, 847, 1313, 1542, 3519, 3868, 2724, 771, 3007, 2103, 3458, 742, 1062, 2887, 530, 2904, 364, 2818, 610, 1101, 3584, 2882, 3162, 413, 1706, 3678, 3528, 654, 504, 4432, 2956, 562, 3118, 2807, 1474, 2177, 1297, 3788, 994, 438, 291, 3720, 1686, 3182, 1846, 2249, 4328, 3599, 3267, 1837, 550, 3400, 4856, 659, 3302, 4719, 3574, 2641, 3307, 4597, 3173, 3766, 658, 1576, 4552, 4491, 4022, 4345, 3913, 4322, 892, 3695, 4869, 2354, 1486, 3320, 3693, 1260, 2345, 4816, 2661, 2868, 945, 3743, 1130, 4370, 2051, 983, 2742, 3433, 1806, 960, 3682, 4241, 1732, 3675, 2566, 1058, 1627, 2460, 4555, 2709, 2447, 457, 3281, 468, 3710, 122, 115, 1887, 4893, 2034, 1049, 1506, 273, 3923, 1427, 4320, 1881, 856, 1149, 4231, 1428, 1267, 1228, 817, 3915, 2747, 424, 4564, 4421, 1593, 4176, 3229, 2226, 3812, 691, 4829, 2940, 3589, 39, 653, 2156, 4772, 238, 2025, 1808, 1411, 4957, 4645, 2647, 275, 1141, 1360, 200, 201, 4931, 2080, 4809, 1179, 896, 4053, 4636, 2518, 247, 1285, 3377, 1094, 2656, 3545, 3797, 3997, 1107, 259, 2506, 1524, 832, 1374, 4153, 2187, 2190, 1783, 811, 4093, 2055, 381, 2152, 1966, 4498, 1100, 3469, 1671, 4364, 3757, 4605, 2681, 3512, 3392, 2331, 4026, 394, 906, 1134, 1564, 4130, 4950, 3555, 4202, 2827, 235, 103, 2847, 3139, 594, 4867, 4967, 4185, 1778, 3422, 1041, 239, 230, 86, 1798, 3326, 4205, 47, 3480, 425, 4746, 4502, 4584, 3136, 1954, 1538, 3767, 1253, 863, 2717, 774, 3159, 2626, 2767, 2832, 1961, 4634, 3468, 823, 3992, 2644, 391, 1741, 2991, 2689, 3784, 129, 3262, 1516, 701, 962, 2862, 4226, 3860, 3786, 1992, 4771, 3255, 185, 2259, 2021, 3039, 1974, 2889, 1343, 256, 3889, 4547, 4897, 2846, 2415, 3854, 1858, 4836, 3168, 272, 568, 814, 4913, 1354, 4333, 4035, 3546, 3270, 1271, 4739, 1622, 339, 3525, 3727, 2583, 4858, 3931, 3349, 3509, 1761, 1605, 2600, 2938, 2713, 4604, 54, 1341, 2443, 441, 3208, 4204, 1754, 370, 4365, 2146, 3350, 3454, 3116, 327, 4876, 4981, 2614, 2664, 2516, 195, 1117, 2318, 410, 4088, 3826, 3780, 1728, 3919, 3738, 3851, 3246, 4825, 2732, 3554, 1162, 3530, 1865, 4315, 2139, 2174, 2935, 3590, 2057, 11, 4849, 2489, 1446, 3444, 3598, 2511, 1142, 1600, 2591, 1979, 798, 4221, 4909, 1136, 3427, 4286, 4977, 1834, 3113, 4124, 1499, 826, 2052, 3463, 2113, 657, 2697, 1688, 866, 538, 3313, 455, 2799, 4325, 3754, 3266, 4417, 4373, 1399, 3212, 4533, 2085, 2022, 1721, 2599, 1790, 3125, 282, 2565, 2, 2029, 3908, 993, 3180, 514, 2918, 3689, 3671, 912, 4008, 322, 1693, 3711, 2324, 1602, 1928, 1366, 4949, 1370, 584, 4084, 1584, 2503, 1187, 3291, 4804, 1885, 453, 69, 3183, 1466, 2289, 148, 2268, 1673, 3909, 816, 4076, 3088, 4362, 4284, 221, 995, 4776, 2966, 1491, 240, 263, 2448, 2136, 2252, 283, 1097, 1139, 667, 2206, 4031, 1317, 949, 3537, 2919, 1629, 1586, 3753, 445, 556, 1435, 1925, 3092, 3205, 2694, 3259, 1372, 1184, 2542, 624, 1726, 2727, 1454, 4256, 3549, 1682, 3974, 2294, 359, 3075, 20, 2835, 4294, 738, 229, 2719, 1103, 4262, 3686, 4667, 3506, 1781, 1841, 2039, 2424, 933, 3700, 4033, 1151, 2072, 1330, 3110, 4483, 4458]


Benchmark.ips do |x|

  x.compare!

  base_array = (0...5_000).to_a

  x.report "array reject, front to back" do
    scratch_array = base_array.dup
    scratch_array = scratch_array.reject { true }
  end

  x.report "array delete_at, front to back" do
    scratch_array = base_array.dup
    scratch_array.delete_at(0) until scratch_array.empty?
  end

  x.report "array slice!, front to back" do
    scratch_array = base_array.dup
    scratch_array.slice!(0) until scratch_array.empty?
  end

  x.report "array slice, front to back" do
    scratch_array = base_array.dup
    scratch_array = scratch_array.slice(1, scratch_array.size - 1) until scratch_array.empty?
  end

  x.report "array drop, front to back" do
    scratch_array = base_array.dup
    scratch_array = scratch_array.drop(1) until scratch_array.empty?
  end

  x.report "array shift, front to back" do
    scratch_array = base_array.dup
    scratch_array.shift until scratch_array.empty?
  end

  x.report "array shift(1), front to back" do
    scratch_array = base_array.dup
    scratch_array.shift(1) until scratch_array.empty?
  end

  x.report "array drop_while, front to back" do
    scratch_array = base_array.dup
    scratch_array.drop_while { true }
  end

  x.report "array delete_if, front to back" do
    scratch_array = base_array.dup
    scratch_array.delete_if { true }
  end

  x.report "array delete, front to back" do
    scratch_array = base_array.dup
    scratch_array.delete(scratch_array.first) until scratch_array.empty?
  end

  x.report "array pop, back to front" do
    scratch_array = base_array.dup
    scratch_array.pop until scratch_array.empty?
  end

  x.report "array pop(1), back to front" do
    scratch_array = base_array.dup
    scratch_array.pop(1) until scratch_array.empty?
  end

  x.report "array delete_at, back to front" do
    scratch_array = base_array.dup
    i = scratch_array.size - 1
    while i > 0
      scratch_array.delete_at(i)
      i -= 1
    end
  end

  x.report "array slice!, back to front" do
    scratch_array = base_array.dup
    i = scratch_array.size - 1
    while i > 0
      scratch_array.slice!(i)
      i -= 1
    end
  end

  x.report "array slice, back to front" do
    scratch_array = base_array.dup
    i = scratch_array.size - 1
    while i > 0
      scratch_array = scratch_array.slice(0, i)
      i -= 1
    end
  end

  x.report "array delete, back to front" do
    scratch_array = base_array.dup
    scratch_array.delete(scratch_array.last) until scratch_array.empty?
  end

  x.report "array take, back to front" do
    scratch_array = base_array.dup
    i = scratch_array.size - 1
    while i > 0
      scratch_array = scratch_array.take(i - 1)
      i -= 1
    end
  end

  x.report "array delete_at, random" do
    scratch_array = base_array.dup
    random_elements.each do |re|
      scratch_array.delete_at(re)
    end
  end

  x.report "array delete, random" do
    scratch_array = base_array.dup
    random_elements.each do |re|
      scratch_array.delete(re)
    end
  end

end
