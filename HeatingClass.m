classdef HeatingClass
    properties
        c_b = 460; % cast iron
        m_b = 20; %?
        m_bf = 50; %?
        p_b = 8000;
        status = 0;
        
        rho_f = 980;
        c_f = 4186;
        md_f = 0.08; %?
        
        rho_t = 8920;
        c_t = 385;
        h_t_in = 100; % ref?
        h_t_out = 0.1;
        k_t = 390;
        r_t_in = 0.015;
        r_t_out = 0.0125;
        l_t = 125/140;
        
        c_r = 880;
        u_r = 10; % ref?
        m_r = 35;
        a_r = 5; %?
        a_r_total = 6*5;
        m_rf = 5;
        
        rho_a = 1.225;
        c_a = 1005;
        v_a = 6725.3/20;
        
        r_w_i = 0.13;
        r_w_o = 0.04;
        k_w = 0.6; % brick
        d_w = 0.3;
        a_w = 50; %?
        c_w = 800; % brick
        rho_w = 1700; % brick
        v_w = 5;
        
        r_win_i = 0.13;
        r_win_o = 0.04;
        r_win_gap = 0.127;
        k_win = 1;
        d_win = 0.012;
        a_win = 5; %?

        T_o = 313
        T = 313.5*ones(15,1);
        T_h = zeros(15,1);
        discomfort_h = zeros(1,1);
        balance_h = zeros(29,1);
        
        p_h = zeros(1,1);

        % exp_outside_temperature = [278.15,278.15,278.15,278.15,277.65,277.65,278.15,278.15,277.65,277.65,277.65,277.15,277.15,277.65,277.65,278.15,278.15,278.15,278.15,278.15,278.15,278.15,277.65,277.65,277.65,277.65,277.65,277.65,277.65,277.65,277.15,277.15,277.15,277.15,277.15,277.15,277.15,277.15,277.15,277.15,276.65,276.65,276.15,276.15,276.15,276.15,276.15,276.65,276.15,276.15,275.65,275.65,275.15,275.15,275.15,275.15,275.65,275.65,275.15,275.15,275.15,275.65,275.65,275.15,275.15,275.15,274.65,274.65,274.65,274.65,274.15,274.15,274.15,274.15,273.65,273.65,274.15,274.15,274.15,274.15,274.15,274.15,274.65,274.65,275.15,275.65,275.65,276.15,276.15,276.65,277.15,277.15,277.65,278.15,278.15,278.15,278.65,278.65,278.65,278.65,278.65,278.65,279.15,279.65,279.65,280.15,280.15,280.65,280.65,281.15,281.65,282.15,282.65,282.65,283.15,283.65,283.65,284.15,284.15,284.65,285.15,285.15,285.15,285.65,285.65,285.65,285.65,285.65,285.65,286.15,286.15,286.15,286.65,286.65,286.65,287.15,287.15,287.65,287.65,288.15,288.15,288.65,288.65,289.15,289.15,289.15,289.15,289.65,289.65,290.15,290.65,290.65,291.15,291.15,291.15,291.65,291.65,291.65,292.15,291.65,291.65,291.65,292.15,292.15,292.15,292.15,292.15,292.15,292.15,292.15,292.15,291.65,292.15,292.15,292.15,292.15,292.15,292.65,292.65,292.15,292.15,292.15,291.65,291.65,291.65,291.65,291.65,291.65,291.15,291.15,291.15,291.65,293.15,294.65,295.15,295.15,294.65,294.15,294.65,294.65,295.15,294.65,295.15,295.15,294.65,294.65,294.15,292.65,292.65,292.65,292.65,292.65,292.15,291.65,291.15,290.65,289.65,289.15,288.15,287.65,286.65,286.15,285.65,285.15,284.65,284.15,284.15,283.65,283.65,283.65,283.15,283.15,283.15,282.65,282.65,282.65,282.65,282.65,282.15,282.15,282.15,282.15,282.15,282.15,282.15,281.65,281.65,281.65,281.65,281.65,281.65,281.15,281.15,281.15,281.15,281.15,281.15,281.15,281.15,281.15,280.65,280.65,280.65,280.65,280.65,280.65,280.65,280.65,280.65,280.65,280.65,280.15,280.15,280.15,280.15,280.15,280.15,280.15,280.15,280.15,280.15,280.15,280.15,280.15,280.15,279.65,280.15,280.15,279.65];
        exp_outside_temperature = [280.9,280.9,280.9,280.9,280.65,280.65,280.9,280.9,280.65,280.65,280.65,280.4,280.4,280.65,280.65,280.9,280.9,280.9,280.9,280.9,280.9,280.9,280.65,280.65,280.65,280.65,280.65,280.65,280.65,280.65,280.4,280.4,280.4,280.4,280.4,280.4,280.4,280.4,280.4,280.4,280.15,280.15,279.9,279.9,279.9,279.9,279.9,280.15,279.9,279.9,279.65,279.65,279.4,279.4,279.4,279.4,279.65,279.65,279.4,279.4,279.4,279.65,279.65,279.4,279.4,279.4,279.15,279.15,279.15,279.15,278.9,278.9,278.9,278.9,278.65,278.65,278.9,278.9,278.9,278.9,278.9,278.9,279.15,279.15,279.4,279.65,279.65,279.9,279.9,280.15,280.4,280.4,280.65,280.9,280.9,280.9,281.15,281.15,281.15,281.15,281.15,281.15,281.4,281.65,281.65,281.9,281.9,282.15,282.15,282.4,282.65,282.9,283.15,283.15,283.4,283.65,283.65,283.9,283.9,284.15,284.4,284.4,284.4,284.65,284.65,284.65,284.65,284.65,284.65,284.9,284.9,284.9,285.15,285.15,285.15,285.4,285.4,285.65,285.65,285.9,285.9,286.15,286.15,286.4,286.4,286.4,286.4,286.65,286.65,286.9,287.15,287.15,287.4,287.4,287.4,287.65,287.65,287.65,287.9,287.65,287.65,287.65,287.9,287.9,287.9,287.9,287.9,287.9,287.9,287.9,287.9,287.65,287.9,287.9,287.9,287.9,287.9,288.15,288.15,287.9,287.9,287.9,287.65,287.65,287.65,287.65,287.65,287.65,287.4,287.4,287.4,287.65,288.4,289.15,289.4,289.4,289.15,288.9,289.15,289.15,289.4,289.15,289.4,289.4,289.15,289.15,288.9,288.15,288.15,288.15,288.15,288.15,287.9,287.65,287.4,287.15,286.65,286.4,285.9,285.65,285.15,284.9,284.65,284.4,284.15,283.9,283.9,283.65,283.65,283.65,283.4,283.4,283.4,283.15,283.15,283.15,283.15,283.15,282.9,282.9,282.9,282.9,282.9,282.9,282.9,282.65,282.65,282.65,282.65,282.65,282.65,282.4,282.4,282.4,282.4,282.4,282.4,282.4,282.4,282.4,282.15,282.15,282.15,282.15,282.15,282.15,282.15,282.15,282.15,282.15,282.15,281.9,281.9,281.9,281.9,281.9,281.9,281.9,281.9,281.9,281.9,281.9,281.9,281.9,281.9,281.65,281.9,281.9,281.65]
        exp_time = [0,300,600,900,1200,1500,1800,2100,2400,2700,3000,3300,3600,3900,4200,4500,4800,5100,5400,5700,6000,6300,6600,6900,7200,7500,7800,8100,8400,8700,9000,9300,9600,9900,10200,10500,10800,11100,11400,11700,12000,12300,12600,12900,13200,13500,13800,14100,14400,14700,15000,15300,15600,15900,16200,16500,16800,17100,17400,17700,18000,18300,18600,18900,19200,19500,19800,20100,20400,20700,21000,21300,21600,21900,22200,22500,22800,23100,23400,23700,24000,24300,24600,24900,25200,25500,25800,26100,26400,26700,27000,27300,27600,27900,28200,28500,28800,29100,29400,29700,30000,30300,30600,30900,31200,31500,31800,32100,32400,32700,33000,33300,33600,33900,34200,34500,34800,35100,35400,35700,36000,36300,36600,36900,37200,37500,37800,38100,38400,38700,39000,39300,39600,39900,40200,40500,40800,41100,41400,41700,42000,42300,42600,42900,43200,43500,43800,44100,44400,44700,45000,45300,45600,45900,46200,46500,46800,47100,47400,47700,48000,48300,48600,48900,49200,49500,49800,50100,50400,50700,51000,51300,51600,51900,52200,52500,52800,53100,53400,53700,54000,54300,54600,54900,55200,55500,55800,56100,56400,56700,57000,57300,57600,57900,58200,58500,58800,59100,59400,59700,60000,60300,60600,60900,61200,61500,61800,62100,62400,62700,63000,63300,63600,63900,64200,64500,64800,65100,65400,65700,66000,66300,66600,66900,67200,67500,67800,68100,68400,68700,69000,69300,69600,69900,70200,70500,70800,71100,71400,71700,72000,72300,72600,72900,73200,73500,73800,74100,74400,74700,75000,75300,75600,75900,76200,76500,76800,77100,77400,77700,78000,78300,78600,78900,79200,79500,79800,80100,80400,80700,81000,81300,81600,81900,82200,82500,82800,83100,83400,83700,84000,84300,84600,84900,85200,85500,85800,86100,86400];
    end
    
    methods
        
        function heating = init(heating, t_length)
            heating.T(15,1) = 296 + 3*rand();
            heating.T_h = zeros(15,t_length);
            heating.discomfort_h = zeros(1,t_length);
            heating.balance_h = zeros(29,t_length);
            heating.p_h = zeros(1,t_length);
        end
        
        function heating = solve(heating, dt, i, h_array, d, occupancy)
            h = h_array(i);
            A = zeros(15,15);
            B = zeros(15,1);

            heating.T_o = heating.outside_temperature(h);

            heating = heating.check_status(occupancy(d,i));
            
            A(1,1) = heating.coef_b_o(dt, heating.md_f, heating.m_b, heating.m_bf);
            A(1,14) = heating.coef_b_i(dt, heating.md_f, heating.m_b, heating.m_bf);
            B(1) = heating.coef_b_r(dt, heating.T(14), heating.T(1), heating.status*heating.p_b, heating.m_b, heating.m_bf);

            A(2,1) = heating.coef_t_i(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            A(2,2) = heating.coef_t_o(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            B(2) = heating.coef_t_r(dt, heating.r_t_in, heating.r_t_out, heating.l_t, heating.T(1), heating.T(2), heating.T_o);

            A(3,2) = heating.coef_r_i(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(3,3) = heating.coef_r_o(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(3,15) = heating.coef_r_e(heating.a_r);
            B(3) = heating.coef_r_r(dt, heating.m_r, heating.m_rf, heating.T(2), heating.T(3));

            A(4,3) = heating.coef_t_i(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            A(4,4) = heating.coef_t_o(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            B(4) = heating.coef_t_r(dt, heating.r_t_in, heating.r_t_out, heating.l_t, heating.T(3), heating.T(4), heating.T_o);

            A(5,4) = heating.coef_r_i(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(5,5) = heating.coef_r_o(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(5,15) = heating.coef_r_e(heating.a_r);
            B(5) = heating.coef_r_r(dt, heating.m_r, heating.m_rf, heating.T(4), heating.T(5));

            A(6,5) = heating.coef_t_i(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            A(6,6) = heating.coef_t_o(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            B(6) = heating.coef_t_r(dt, heating.r_t_in, heating.r_t_out, heating.l_t, heating.T(5), heating.T(6), heating.T_o);

            A(7,6) = heating.coef_r_i(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(7,7) = heating.coef_r_o(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(7,15) = heating.coef_r_e(heating.a_r);
            B(7) = heating.coef_r_r(dt, heating.m_r, heating.m_rf, heating.T(6), heating.T(7));

            A(8,7) = heating.coef_t_i(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            A(8,8) = heating.coef_t_o(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            B(8) = heating.coef_t_r(dt, heating.r_t_in, heating.r_t_out, heating.l_t, heating.T(7), heating.T(8), heating.T_o);

            A(9,8) = heating.coef_r_i(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(9,9) = heating.coef_r_o(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(9,15) = heating.coef_r_e(heating.a_r);
            B(9) = heating.coef_r_r(dt, heating.m_r, heating.m_rf, heating.T(8), heating.T(9));

            A(10,9) = heating.coef_t_i(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            A(10,10) = heating.coef_t_o(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            B(10) = heating.coef_t_r(dt, heating.r_t_in, heating.r_t_out, heating.l_t, heating.T(9), heating.T(10), heating.T_o);

            A(11,10) = heating.coef_r_i(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(11,11) = heating.coef_r_o(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(11,15) = heating.coef_r_e(heating.a_r);
            B(11) = heating.coef_r_r(dt, heating.m_r, heating.m_rf, heating.T(10), heating.T(11));

            A(12,11) = heating.coef_t_i(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            A(12,12) = heating.coef_t_o(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            B(12) = heating.coef_t_r(dt, heating.r_t_in, heating.r_t_out, heating.l_t, heating.T(11), heating.T(12), heating.T_o);

            A(13,12) = heating.coef_r_i(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(13,13) = heating.coef_r_o(dt, heating.md_f, heating.m_r, heating.a_r, heating.m_rf);
            A(13,15) = heating.coef_r_e(heating.a_r);
            B(13) = heating.coef_r_r(dt, heating.m_r, heating.m_rf, heating.T(12), heating.T(13));

            A(14,13) = heating.coef_t_i(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            A(14,14) = heating.coef_t_o(dt, heating.md_f, heating.r_t_in, heating.r_t_out, heating.l_t);
            B(14) = heating.coef_t_r(dt, heating.r_t_in, heating.r_t_out, heating.l_t, heating.T(13), heating.T(14), heating.T_o);

            A(15,2) = heating.coef_e_i(heating.a_r);
            A(15,3) = heating.coef_e_o(heating.a_r);
            A(15,4) = heating.coef_e_i(heating.a_r);
            A(15,5) = heating.coef_e_o(heating.a_r);
            A(15,6) = heating.coef_e_i(heating.a_r);
            A(15,7) = heating.coef_e_o(heating.a_r);
            A(15,8) = heating.coef_e_i(heating.a_r);
            A(15,9) = heating.coef_e_o(heating.a_r);
            A(15,10) = heating.coef_e_i(heating.a_r);
            A(15,11) = heating.coef_e_o(heating.a_r);
            A(15,12) = heating.coef_e_i(heating.a_r);
            A(15,13) = heating.coef_e_o(heating.a_r);
            A(15,15) = heating.coef_e_e(dt, heating.v_a, heating.a_r_total, heating.d_w, heating.a_w, heating.v_w, heating.d_win, heating.a_win);
            B(15) = heating.coef_e_r(dt, heating.v_a, heating.d_w, heating.a_w, heating.v_w, heating.d_win, heating.a_win, heating.T(15), heating.T_o);

            heating.T=A\B;
            
            heating.T_h(:,i) = heating.T(:);
            heating.p_h(i) = heating.status * heating.p_b;

            if((occupancy(d,i))&&((heating.T(15)>299)||(heating.T(15)<296)))
                heating.discomfort_h(i) = 1;
            else
                heating.discomfort_h(i) = 0;
            end
            
            heating.balance_h(1,i) = heating.power_boiler_water( heating.T(14), heating.T(1));
            heating.balance_h(2,i) = heating.power_tube_transfer(heating.T(1), heating.T(2));
            heating.balance_h(3,i) = heating.power_tube_loss(heating.T(1), heating.T(2));
            heating.balance_h(4,i) = heating.power_radiator_transfer(heating.T(2), heating.T(3));
            heating.balance_h(5,i) = heating.power_radiator_environment(heating.T(2), heating.T(3), heating.T(15));
            heating.balance_h(6,i) = heating.power_tube_transfer(heating.T(3), heating.T(4));
            heating.balance_h(7,i) = heating.power_tube_loss(heating.T(3), heating.T(4));
            heating.balance_h(8,i) = heating.power_radiator_transfer(heating.T(4), heating.T(5));
            heating.balance_h(9,i) = heating.power_radiator_environment(heating.T(4), heating.T(5), heating.T(15));
            heating.balance_h(10,i) = heating.power_tube_transfer(heating.T(5), heating.T(6));
            heating.balance_h(11,i) = heating.power_tube_loss(heating.T(5), heating.T(6));
            heating.balance_h(12,i) = heating.power_radiator_transfer(heating.T(6), heating.T(7));
            heating.balance_h(13,i) = heating.power_radiator_environment(heating.T(6), heating.T(7), heating.T(15));
            heating.balance_h(14,i) = heating.power_tube_transfer(heating.T(7), heating.T(8));
            heating.balance_h(15,i) = heating.power_tube_loss(heating.T(7), heating.T(8));
            heating.balance_h(16,i) = heating.power_radiator_transfer(heating.T(8), heating.T(9));
            heating.balance_h(17,i) = heating.power_radiator_environment(heating.T(8), heating.T(9), heating.T(15));
            heating.balance_h(18,i) = heating.power_tube_transfer(heating.T(9), heating.T(10));
            heating.balance_h(19,i) = heating.power_tube_loss(heating.T(9), heating.T(10));
            heating.balance_h(20,i) = heating.power_radiator_transfer(heating.T(10), heating.T(11));
            heating.balance_h(21,i) = heating.power_radiator_environment(heating.T(10), heating.T(11), heating.T(15));
            heating.balance_h(22,i) = heating.power_tube_transfer(heating.T(11), heating.T(12));
            heating.balance_h(23,i) = heating.power_tube_loss(heating.T(11), heating.T(12));
            heating.balance_h(24,i) = heating.power_radiator_transfer(heating.T(12), heating.T(13));
            heating.balance_h(25,i) = heating.power_radiator_environment(heating.T(12), heating.T(13), heating.T(15));
            heating.balance_h(26,i) = heating.power_tube_transfer(heating.T(13), heating.T(14));
            heating.balance_h(27,i) = heating.power_tube_loss(heating.T(13), heating.T(14));
            heating.balance_h(28,i) = heating.power_environment_wall_loss(heating.T(15));
            heating.balance_h(29,i) = heating.power_environment_window_loss(heating.T(15));  

        end
        function heating = check_status(heating, is_occupied)
            if((heating.T(15)>298)||(~is_occupied))
                heating.status = 0;
                heating.md_f = 0.1;
            elseif(heating.T(15)<297)
                heating.status = 1;
                heating.md_f = 1.3/17;
            end
            
        end
        
        % boiler
        function c = coef_b_i(heating, dt, md_f, m_b, m_bf) % coefficient of inlet temperature of boiler (return water)
            c = (m_b*heating.c_b+m_bf*heating.c_f)/(2*dt)-md_f*heating.c_f;
        end
        function c = coef_b_o(heating, dt, md_f, m_b, m_bf) % coefficient of outlet temperature of boiler (supply water)
            c = (m_b*heating.c_b+m_bf*heating.c_f)/(2*dt)+md_f*heating.c_f;
        end
        function c = coef_b_r(heating, dt, T_b_i, T_b_o, p_b, m_b, m_bf) % right-hand coefficient of boiler
            c = p_b + (m_b*heating.c_b+m_bf*heating.c_f)/(2*dt)*(T_b_i + T_b_o);
        end
        function p = power_boiler_water(heating, T_b_i, T_b_o)
            p = heating.md_f * heating.c_f * (T_b_o - T_b_i);
        end
        % boiler
        
        % tube
        function A = tube_area(~, r_t_in, l_t) % inner area of tube
            A = 2*pi*r_t_in*l_t;
        end
        function U = tube_heat_transfer(heating, r_t_in, r_t_out) % equivalent heat transfer coefficient of tube
            U = 1/(1/heating.h_t_in+(r_t_in*log(r_t_out/r_t_in))/heating.k_t+r_t_in/(r_t_out*heating.h_t_out));
        end
        function m = tube_mass(heating, r_t_in, r_t_out, l_t) % weight of tube
            m = pi*heating.rho_t*(r_t_out^2-r_t_in^2)*l_t;
        end
        function m = tube_fluid_mass(heating, r_t_in, l_t) % weight of fluid inside tube
            m = pi*heating.rho_f*r_t_in^2*l_t;
        end
        function c = coef_t_i(heating, dt, md_f, r_t_in, r_t_out, l_t) % coefficient of inlet temperature of tube
            c = (heating.tube_mass(r_t_in, r_t_out, l_t)*heating.c_t+heating.tube_fluid_mass(r_t_in, l_t)*heating.c_f)/(2*dt)-md_f*heating.c_f+heating.tube_heat_transfer(r_t_in, r_t_out)*heating.tube_area(r_t_in, l_t)/2;
        end
        function c = coef_t_o(heating, dt, md_f, r_t_in, r_t_out, l_t) % coefficient of outlet temperature of tube
            c = (heating.tube_mass(r_t_in, r_t_out, l_t)*heating.c_t+heating.tube_fluid_mass(r_t_in, l_t)*heating.c_f)/(2*dt)+md_f*heating.c_f+heating.tube_heat_transfer(r_t_in, r_t_out)*heating.tube_area(r_t_in, l_t)/2;
        end
        function c = coef_t_r(heating, dt, r_t_in, r_t_out, l_t, T_t_i, T_t_o, T_o) % right-hand coefficient of tube
            c = heating.tube_heat_transfer(r_t_in, r_t_out)*heating.tube_area(r_t_in, l_t)*T_o + (heating.tube_mass(r_t_in, r_t_out, l_t)*heating.c_t+heating.tube_fluid_mass(r_t_in, l_t)*heating.c_f)*(T_t_i+T_t_o)/(2*dt);
        end
        function p = power_tube_transfer(heating, T_t_i, T_t_o)
            p = heating.md_f * heating.c_f * (T_t_o - T_t_i);
        end
        function p = power_tube_loss(heating, T_t_i, T_t_o)
            p = heating.tube_heat_transfer(heating.r_t_in, heating.r_t_out)*heating.tube_area(heating.r_t_in, heating.l_t)*(heating.T_o-(T_t_i+T_t_o)/2);
        end
        %tube
        
        %radiator
        function c = coef_r_i(heating, dt, md_f, m_r, a_r, m_rf) % coefficient of inlet temperature of radiator
            c = (m_r*heating.c_r+m_rf*heating.c_f)/(2*dt)-md_f*heating.c_f+heating.u_r*a_r/2;
        end
        function c = coef_r_o(heating, dt, md_f, m_r, a_r, m_rf) % coefficient of outlet temperature of radiator
            c = (m_r*heating.c_r+m_rf*heating.c_f)/(2*dt)+md_f*heating.c_f+heating.u_r*a_r/2;
        end
        function c = coef_r_e(heating, a_r) % coefficient of envioronment temperature of radiator
            c = -heating.u_r*a_r;
        end
        function c = coef_r_r(heating, dt, m_r, m_rf, T_r_i, T_r_o) % right-hand coefficient of radiator
            c = (m_r*heating.c_r+m_rf*heating.c_f)*(T_r_i+T_r_o)/(2*dt);
        end
        function p = power_radiator_transfer(heating, T_r_i, T_r_o)
            p = heating.md_f * heating.c_f * (T_r_o - T_r_i);
        end
        function p = power_radiator_environment(heating, T_r_i, T_r_o, T_e)
            p = heating.u_r*heating.a_r*(T_e-(T_r_i+T_r_o)/2);
        end
        %radiator
        
        %evironment
        function U = wall_heat_transfer(heating, d_w) % equivalent heat transfer coefficient of wall
            U = 1/(heating.r_w_o+d_w/heating.k_w+heating.r_w_i);
        end
        function U = window_heat_transfer(heating, d_win) % equivalent heat transfer coefficient of window
            U = 1/(heating.r_win_o+d_win/heating.k_win+heating.r_win_gap+heating.r_win_i);
        end
        function c = coef_e_i(heating, a_r) % coefficient of radiator inlet temperature of environment
            c = -heating.u_r*a_r/2;
        end
        function c = coef_e_o(heating, a_r) % coefficient of radiator outlet temperature of environment
            c = -heating.u_r*a_r/2;
        end
        function c = coef_e_e(heating, dt, v_a, a_r_total, d_w, a_w, v_w, d_win, a_win) % coefficient of environment temperature of environment
            c = (heating.rho_a*v_a*heating.c_a+heating.rho_w*v_w*heating.c_w)/dt + heating.u_r*a_r_total + heating.wall_heat_transfer(d_w)*a_w + heating.window_heat_transfer(d_win)*a_win;
        end
        function c = coef_e_r(heating, dt, v_a, d_w, a_w, v_w, d_win, a_win, T_e, T_o) % right-hand coefficient of environment
            c = ((heating.rho_a*v_a*heating.c_a+heating.rho_w*v_w*heating.c_w)/dt)*T_e + (heating.wall_heat_transfer(d_w)*a_w+heating.window_heat_transfer(d_win)*a_win)*T_o;
        end
        function p = power_environment_wall_loss(heating, T_e)
            p = heating.wall_heat_transfer(heating.d_w)*heating.a_w*(heating.T_o - T_e);
        end
        function p = power_environment_window_loss(heating, T_e)
            p = heating.window_heat_transfer(heating.d_win)*heating.a_win*(heating.T_o - T_e);
        end
        %evironment
        
        %experiment%
        function T = outside_temperature(heating, t)
            T = interp1(heating.exp_time/3600, heating.exp_outside_temperature, t);
        end
        function T = return_temperature(heating, t)
            T = interp1(heating.exp_time/3600, heating.exp_return, t);
        end
        function T = supply_temperature(heating, t)
            T = interp1(heating.exp_time/3600, heating.exp_supply, t);
        end
        %experiment%
    end
end

