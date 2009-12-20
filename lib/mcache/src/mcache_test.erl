-module(mcache_test).
-author('echou327@gmail.com').

-compile(export_all).

test_get_server(P, R) ->
    F = fun(I) ->
            %mcache:get_server(mcache.test, <<"key:", I:32>>)
            V = mcache_continuum:find(generic, mcache_util:hash(<<"mcache.test:key:", I:32>>, md5)),
            %io:format("~p~n", [V])
            V
        end,
    stresstest:start("test_get", P, R, F).

test_get(P, R) ->
    F = fun(I) ->
            mcache:get(mcache.test, <<"key:", I:32>>)
        end,
    stresstest:start("test_get", P, R, F).

test_set(P, R, M, Size) ->
    S = Size * 8,
    F = fun(I) ->
            M:set(mcache.test, "key:" ++ integer_to_list(I), <<"value:", I:S>>, raw, 0)
        end,
    stresstest:start("test_set", P, R, F).


test_mget(P, R, M) ->
    F = fun(I) ->
            M:mget(mcache.test, [<<"key:", V:32>> || V <- lists:seq(I, I + 20)])
        end,
    stresstest:start("test_mget", P, R, F).

test_mget2(P, R, M) ->
    F = fun(I) ->
            M:mget(mcache.test, [<<"key:", V:32>> || V <- lists:seq(I, I + 20)])
        end,
    stresstest:start("test_mget", P, R, F).

gen_continuum(Mode) ->
    Servers = [
        {{10,0,1,1}, 11211, 600},
        {{10,0,1,2}, 11211, 300},
        {{10,0,1,3}, 11211, 200},
        {{10,0,1,4}, 11211, 350},
        {{10,0,1,5}, 11211, 1000},
        {{10,0,1,6}, 11211, 800},
        {{10,0,1,7}, 11211, 950},
        {{10,0,1,8}, 11211, 100}
    ],
    mcache_continuum_gen:gen([{generic, Servers},{foobar, Servers}], Mode).


validate_continuum(Mode) ->
    Servers = [
        {{10,0,1,1}, 11211, 600},
        {{10,0,1,2}, 11211, 300},
        {{10,0,1,3}, 11211, 200},
        {{10,0,1,4}, 11211, 350},
        {{10,0,1,5}, 11211, 1000},
        {{10,0,1,6}, 11211, 800},
        {{10,0,1,7}, 11211, 950},
        {{10,0,1,8}, 11211, 100}
    ],

    %testcases for ketama_weighted + md5
    TestCases = [
        { "SVa_]_V41)", 443691461, 445379617, {10,0,1,7} },
        { "*/Z;?V(.\\8", 1422915503, 1428303028, {10,0,1,1} },
        { "30C1*Z*S/_", 1473165754, 1480075959, {10,0,1,2} },
        { "ERR:EC58G>", 2148406511, 2168579133, {10,0,1,7} },
        { "1I=cTMNTKF", 2882686667, 2885206587, {10,0,1,5} },
        { "]VG<`I*Z8)", 1103544263, 1104827657, {10,0,1,5} },
        { "UUTC`-V159", 3716288206, 3727224240, {10,0,1,5} },
        { "@7RU6C6T+Z", 3862737685, 3871917949, {10,0,1,5} },
        { "/XLN0@+36;", 1623269830, 1627683651, {10,0,1,1} },
        { "4(`X;\\V.^c", 373546328, 383925769, {10,0,1,1} },
        { "726bW=9*a4", 4213440020, 4213950705, {10,0,1,7} },
        { "\\`)<B)UE,c", 951096736, 955226069, {10,0,1,1} },
        { "P1[Ma3=K1/", 1989324036, 1994028240, {10,0,1,8} },
        { "C89I.-V?cT", 1604239957, 1606398093, {10,0,1,8} },
        { "D[HE+cFXDK", 2117036136, 2117124014, {10,0,1,3} },
        { "P1L?NAB[)K", 2129972569, 2132542634, {10,0,1,1} },
        { "cDT0)Z5P6,", 176485284, 178675413, {10,0,1,5} },
        { "@JW`+[WAO8", 2720940826, 2743975456, {10,0,1,5} },
        { "\\39DKW^)N_", 3548879868, 3550704865, {10,0,1,3} },
        { "EM75N0+[X1", 1558531507, 1559308507, {10,0,1,4} },
        { "`,SS]NBP,b", 1883545960, 1884847278, {10,0,1,1} },
        { "XX1a9LT+F?", 653487707, 656410408, {10,0,1,5} },
        { "Zc\\-,F-c6V", 1160802451, 1171575728, {10,0,1,5} },
        { "1*RTMC7,03", 1602398012, 1606398093, {10,0,1,8} },
        { "*Xc+V0P>32", 536016577, 539988520, {10,0,1,7} },
        { "U))Fb-(`,.", 4128682289, 4136854163, {10,0,1,7} },
        { "R-08RNTaRT", 3718170086, 3727224240, {10,0,1,5} },
        { "(LHcO203I3", 1007779411, 1014643570, {10,0,1,5} },
        { "=256P+;Qc8", 3976201210, 3976304873, {10,0,1,5} },
        { "OI5XZ_BBT(", 2155922164, 2168579133, {10,0,1,7} },
        { "2TLRL/UL;:", 1086800909, 1095659802, {10,0,1,7} },             
        { "WHD\\O1`ZRW", 3087923411, 3095471560, {10,0,1,5} },
        { ".=54)_c;=T", 2497691631, 2502731301, {10,0,1,1} },
        { ";G<W-XWZ@b", 2888169733, 2888728739, {10,0,1,5} },
        { "(,>E`)FT\\4", 580747448, 581063326, {10,0,1,2} },
        { "HZAU*;P*N]", 2564670474, 2565697267, {10,0,1,7} },
        { "NZ@ZE=O84_", 533335275, 539988520, {10,0,1,7} },
        { "6,cEI`F_P>", 3972869246, 3974773167, {10,0,1,6} },
        { "c,5AQ/T5)6", 2835605783, 2847870057, {10,0,1,8} },
        { ".O,>>BT)RX", 3857978174, 3871917949, {10,0,1,5} },
        { "XY\\X::LX50", 1749241099, 1752196488, {10,0,1,6} },
        { "+550F^/.01", 3781824099, 3783248219, {10,0,1,6} },
        { "<.X9E2S5+9", 3232479481, 3234387706, {10,0,1,7} },
        { "]\\.UH8_0a1", 2419699252, 2423002920, {10,0,1,4} },
        { "8(6=(T0/Z0", 728266737, 729026070, {10,0,1,7} },
        { "8*6a;Sc*X+", 4223431086, 4230156966, {10,0,1,2} },
        { "<QW:;3K6;H", 2731158143, 2743975456, {10,0,1,5} },
        { "7C@EY@-Y?_", 760770733, 761576669, {10,0,1,5} },
        { "aPb3E1WD4K", 2500489218, 2502731301, {10,0,1,1} },
        { "?@12R<=1BH", 1494795329, 1502505505, {10,0,1,8} },
        { "QR(a+Q=1FU", 3238535074, 3238996435, {10,0,1,6} },
        { "`C9^FV,960", 2628553463, 2628733766, {10,0,1,6} },
        { "UNHVP..^8H", 977096483, 977319837, {10,0,1,4} },
        { ":Y.2W2[(35", 2777083668, 2784182515, {10,0,1,7} },
        { "M/HV^_HZ4O", 3623390946, 3624445007, {10,0,1,7} },
        { "ZY16KQ<ICD", 1831153193, 1838563516, {10,0,1,4} },
        { "bV2,`a.PY9", 1962228869, 1962648654, {10,0,1,1} },
        { "U;9:-+5N]9", 269504649, 277560877, {10,0,1,1} },
        { "1S/:aJ[1(;", 578069729, 581063326, {10,0,1,2} },
        { "Nb-X^]M)I:", 330865696, 331009896, {10,0,1,6} },
        { "2;M;ES>J5/", 2776949824, 2784182515, {10,0,1,7} },
        { "[>RZHG97Q9", 71954686, 72034069, {10,0,1,6} },
        { "J3/G[)9<^Z", 2799896459, 2805183696, {10,0,1,7} },
        { "N-)88>[O`,", 50404102, 51792557, {10,0,1,5} },
        { "NP:=FR\\OaA", 3837333776, 3837792034, {10,0,1,7} },
        { "`@L+W;a,O[", 1512157148, 1522285852, {10,0,1,6} },
        { "W2`P:-+1T[", 2945171975, 2946196424, {10,0,1,5} },
        { "-6G7K^YDIN", 3168617340, 3170513015, {10,0,1,7} },
        { "U>*>9ZI6V5", 668514946, 674097631, {10,0,1,6} },
        { ".I?^6Ic9RK", 938419020, 942832691, {10,0,1,6} },
        { "0OZH^9BKM[", 3682518606, 3686781297, {10,0,1,8} },
        { "5?50UGZ:ML", 868610882, 869425986, {10,0,1,5} },
        { "?K2NF@3=IU", 381218851, 383925769, {10,0,1,1} },
        { "YI@G-2X?UB", 3688706179, 3693197681, {10,0,1,5} },
        { "7cY</BSaL=", 3976870223, 3978903843, {10,0,1,6} },
        { "A(`KF:[RH8", 3292979676, 3294849139, {10,0,1,6} },
        { ";=ZT\\W^P+H", 1401102653, 1416290674, {10,0,1,4} },
        { "b2?WFF56;R", 480494704, 486971192, {10,0,1,4} },
        { "CTR74,J+N.", 137446045, 146633907, {10,0,1,8} },
        { "<b;*R+QDST", 1304985302, 1308223778, {10,0,1,5} },
        { "\\R^7=9UCG`", 126218373, 129199837, {10,0,1,5} },
        { "1bQS5]WOXB", 1853470245, 1855329369, {10,0,1,4} },
        { "M(@X^b[L:K", 3019630308, 3022260113, {10,0,1,1} },
        { "431cBF8,YO", 1679726993, 1685224295, {10,0,1,7} },
        { "(bEIQJ:E./", 2922607787, 2925521819, {10,0,1,6} },
        { "WS/3H*)7F;", 419488232, 422140585, {10,0,1,5} },
        { "ZJF[Ia6Q)+", 3960568056, 3962489998, {10,0,1,7} },
        { "<]*QCK8U,>", 2590140172, 2598117636, {10,0,1,7} },
        { "\\[a\\^=V_M0", 689410119, 698690782, {10,0,1,6} },
        { "7;RM+8J9YC", 1530175299, 1531107082, {10,0,1,7} },
        { "4*=.SPR[AV", 3928582722, 3928853792, {10,0,1,1} },
        { "-2F+^88P4U", 3023552752, 3025823613, {10,0,1,7} },
        { "X;-F`(N?9D", 570465234, 572485994, {10,0,1,7} },
        { "R=F_D-K2a]", 1287750228, 1290935562, {10,0,1,7} },
        { "X*+2aaC.EG", 3200948713, 3201088518, {10,0,1,5} },
        { "[1ZXONX2]a", 4108881567, 4109865744, {10,0,1,4} },
        { "FL;\\GWacaV", 458449508, 467374054, {10,0,1,4} },
        { "\\MQ_XNT7L-", 1259349383, 1259509450, {10,0,1,7} },
        { "VD6D0]ba_\\", 3842502950, 3842588691, {10,0,1,1} },
        { "VDEAAAAA", 4294758837, 2148620, {10,0,1,3}}                %wraps around to the first (smallest) key
    ],

    mcache_continuum_gen:gen([{generic, Servers}], Mode),

    Errors =    lists:foldl(fun({Key, _, _, Server}, Errors) ->
                                %io:format("find_server Key = ~p ~n", [Key]),
                                {ResultServer,_} = mcache_continuum:find(generic, mcache_util:hash(Key, md5)),
                                if Server=:= ResultServer ->  
                                    Errors;
                                true -> 
                                    [{{key,Key}, {result,ResultServer}, {expected, Server}}]++Errors
                                end
                            end,
                            [],
                            TestCases),

    io:format("Errors : ~p ~n", [Errors]).


