

library ieee;
library STD;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;
 


entity coffe2 is
port(
    clk, reset : in std_logic;
    caffe_b : in std_logic;
	 cappuccino_b : in std_logic;
	 ricarica_b : in std_logic;
	 c1 : in std_logic;
	 c2 : in std_logic;
	 c3 : in std_logic;
	 c4 : in std_logic;

    LED_out : out bit_vector (0 to 6);
	 LED_reg_1 : out bit_vector (0 to 6);
	 LED_reg_0 : out bit_vector (0 to 6);
	 LED_next_1 : out bit_vector (0 to 6);
	 LED_next_0 : out bit_vector (0 to 6);
	 LED_reset : out bit_vector (0 to 6)

);
end coffe2;

architecture arch of coffe2 is 
    
	type stateMealy_type is (zero, uno,due,tre,quattro,cinque,sei, sette, otto, nove, dieci, undici, dodici, tredici, quattordici, quindici); -- 16 states are required for Mealy
	signal stateMealy_reg, stateMealy_next : stateMealy_type;
	signal count: integer:=0;
	signal max: integer:=50000;
	signal interval_m: integer:=45000;
	signal interval_p: integer:=5000;
	signal caffe: std_logic :='0';
	signal cappuccino: std_logic :='0';
	signal ricarica: std_logic :='0';	 	 
	signal tmp : std_logic := '0';
	signal clock_out:  std_logic:='0';
	 
begin

process(clk)
begin
if(clk'event and clk='1') then
count <=count+1;
if (count = max) then
tmp <= NOT tmp;
count <= 1;
end if;
end if;
clock_out <= tmp;
end process;



process(clock_out, reset,stateMealy_reg,count)
begin
	     
			
        if (reset = '1') then -- go to state zero if reset
		  		LED_reset<= "1001111";
            if ((c1='0')and(c2='0')and(c3='0')and(c4='0')) then
				stateMealy_reg <= zero;--stato iniziale deciso dall'importo presente sulla chiavetta
            elsif ((c1='0')and(c2='0')and(c3='0')and(c4='1')) then
				stateMealy_reg <= uno;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='0')and(c2='0')and(c3='1')and(c4='0')) then
				stateMealy_reg <= due;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='0')and(c2='0')and(c3='1')and(c4='1')) then
				stateMealy_reg <= tre;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='0')and(c2='1')and(c3='0')and(c4='0')) then
				stateMealy_reg <= quattro;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='0')and(c2='1')and(c3='0')and(c4='1')) then
				stateMealy_reg <= cinque;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='0')and(c2='1')and(c3='1')and(c4='0')) then
				stateMealy_reg <= sei;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='0')and(c2='1')and(c3='1')and(c4='1')) then
				stateMealy_reg <= sette;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='1')and(c2='0')and(c3='0')and(c4='0')) then
				stateMealy_reg <= otto;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='1')and(c2='0')and(c3='0')and(c4='1')) then
				stateMealy_reg <= nove;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='1')and(c2='0')and(c3='1')and(c4='0')) then
				stateMealy_reg <= dieci;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='1')and(c2='0')and(c3='1')and(c4='1')) then
				stateMealy_reg <= undici;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='1')and(c2='1')and(c3='0')and(c4='0')) then
				stateMealy_reg <= dodici;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='1')and(c2='1')and(c3='0')and(c4='1')) then
				stateMealy_reg <= tredici;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='1')and(c2='1')and(c3='1')and(c4='0')) then
				stateMealy_reg <= quattordici;--stato iniziale deciso dall'importo presente sulla chiavetta
				elsif ((c1='1')and(c2='1')and(c3='1')and(c4='1')) then
				stateMealy_reg <= quindici;--stato iniziale deciso dall'importo presente sulla chiavetta
				
				end if;
				
        elsif (count = interval_m and clock_out = '0') then -- otherwise update the states
            stateMealy_reg <= stateMealy_next;
				LED_reset<= "0000001";
 

        end if; 
    end process;

	
	process (caffe_b,count,clock_out)
	begin
	
		if (caffe_b'event and caffe_b = '1') then
			caffe <= '1';
		end if;
		if (count=interval_p and clock_out = '1') then 	caffe <= '0';
		end if;

	end process;
	process (cappuccino_b,count,clock_out)
	begin
	
		if (cappuccino_b'event and cappuccino_b = '1') then
			cappuccino <= '1';
		end if;
		if (count=interval_p and clock_out = '1') then 	cappuccino <= '0';
		end if;

	end process;
	process (ricarica_b,count,clock_out)
	begin
	
		if (ricarica_b'event and ricarica_b = '1') then
			ricarica <= '1';
		end if;
		if (count=interval_p and clock_out = '1') then 	ricarica <= '0';
		end if;

	end process;

    -- Mealy Design
    process(stateMealy_reg, caffe,cappuccino,ricarica,reset,clock_out, count)
		begin 
		
			-- store current state as next
        if (reset = '1') then -- otherwise update the states
          if(count = interval_m and clock_out = '0') then
			 stateMealy_next <= stateMealy_reg; -- required: when no case statement is satisfied
			end if;

			elsif (clock_out'event and clock_out = '1')then	
			

        
        case stateMealy_reg is 
            
			when zero => 
					LED_reg_1<= "0000001";
					LED_reg_0<= "0000001";

					 --
                if (caffe = '1') then  
                    stateMealy_next <= zero;			--NON PERMESSO
						  LED_out <= "0110000";
                elsif (cappuccino = '1') then  
                    stateMealy_next <= zero; 		--NON PERMESSO
						  LED_out <= "0110000";
                elsif (ricarica = '1') then  
                    stateMealy_next <= dieci;
						  LED_out <= "0111000"; 
                end if;			 
					 
					 
			  when uno => 
					 --
					LED_reg_1<= "0000001";
					LED_reg_0<= "1001111";

                if (caffe = '1') then  
                    stateMealy_next <= uno;			--NON PERMESSO
						  LED_out <= "0110000";
                elsif (cappuccino = '1') then  
                    stateMealy_next <= uno; 			--NON PERMESSO
						  LED_out <= "0110000";
                elsif (ricarica = '1') then  
                    stateMealy_next <= undici;
						  LED_out <= "0111000";
                end if;
					
				when due => 
					 --
					LED_reg_1<= "0000001";
					LED_reg_0<= "0010010";

                if caffe = '1' then  
                    stateMealy_next <= due;			--NON PERMESSO
						  LED_out <= "0110000";
                elsif cappuccino = '1' then  
                    stateMealy_next <= due; 			--NON PERMESSO
						  LED_out <= "0110000";
                elsif ricarica = '1' then  
                    stateMealy_next <= dodici;
						  LED_out <= "0111000";
                end if;
					 
				when tre => 
					 --
					LED_reg_1<= "0000001";
					LED_reg_0<= "0000110";

                if caffe = '1' then  
                    stateMealy_next <= tre;			--NON PERMESSO
						  LED_out <= "0110000";
                elsif cappuccino = '1' then  
                    stateMealy_next <= tre; 			--NON PERMESSO
						  LED_out <= "0110000";
                elsif ricarica = '1' then  
                    stateMealy_next <= tredici;
						  LED_out <= "0111000";
                end if;
					 
				when quattro => 
					 --
					LED_reg_1<= "0000001";
					LED_reg_0<= "1001100";

                if caffe = '1' then  
                    stateMealy_next <= quattro;			--NON PERMESSO
						  LED_out <= "0110000";
                elsif cappuccino = '1' then  
                    stateMealy_next <= quattro; 		--NON PERMESSO
						  LED_out <= "0110000";
                elsif ricarica = '1' then  
                    stateMealy_next <= quattordici;
						  LED_out <= "0111000";
                end if;
					 
				when cinque => 
					 --
					LED_reg_1<= "0000001";
					LED_reg_0<= "0100100";

                if caffe = '1' then  
                    stateMealy_next <= zero;	
						  LED_out <= "0110001";
                elsif cappuccino = '1' then  
                    stateMealy_next <= cinque; 			--NON PERMESSO
						  LED_out <= "0110000";
                elsif ricarica = '1' then  
                    stateMealy_next <= quindici;		--NON PERMESSO
						  LED_out <= "0111000";					

                end if;
			
				when sei => 
					 --
					LED_reg_1<= "0000001";
					LED_reg_0<= "0100000";

                if caffe = '1' then  
                    stateMealy_next <= uno;
						  LED_out <= "0110001";
                elsif cappuccino = '1' then  
                    stateMealy_next <= zero; 
						  LED_out <= "0000010";
                elsif ricarica = '1' then  
                    stateMealy_next <= sei;				--NON PERMESSO
						  LED_out <= "0110000";
                end if;
					
				when sette => 
					 --
					LED_reg_1<= "0000001";
					LED_reg_0<= "0001111";

                if caffe = '1' then  
                    stateMealy_next <= due;	
						  LED_out <= "0110001";
                elsif cappuccino = '1' then  
                    stateMealy_next <= uno; 	
					     LED_out <= "0000010";	  
                elsif ricarica = '1' then  
                    stateMealy_next <= sette;			--NON PERMESSO
						  LED_out <= "0110000";
                end if;

				when otto => 
					 --
					LED_reg_1<= "0000001";
					LED_reg_0<= "0000000";

                if caffe = '1' then  
                    stateMealy_next <= tre;	
						  LED_out <= "0110001";
                elsif cappuccino = '1' then  
                    stateMealy_next <= due; 
				        LED_out <= "0000010";		  
                elsif ricarica = '1' then  
                    stateMealy_next <= otto;				--NON PERMESSO
						  LED_out <= "0110000";
                end if;

				when nove => 
					 --
					LED_reg_1<= "0000001";
					LED_reg_0<= "0000100";

                if caffe = '1' then  
                    stateMealy_next <= quattro;	
						  LED_out <= "0110001";  
                elsif cappuccino = '1' then  
                    stateMealy_next <= tre; 
				        LED_out <= "0000010";		  
                elsif ricarica = '1' then  
                    stateMealy_next <= nove;				--NON PERMESSO
						  LED_out <= "0110000";
                end if;

				when dieci => 
					 --
					LED_reg_1<= "1001111";
					LED_reg_0<= "0000001";
										
                if caffe = '1' then  
                    stateMealy_next <= cinque;
					     LED_out <= "0110001";	  
                elsif cappuccino = '1' then  
                    stateMealy_next <= quattro; 
						  LED_out <= "0000010";  
                elsif ricarica = '1' then  
                    stateMealy_next <= dieci;		--NON PERMESSO
						  LED_out <= "0110000";
                end if;

				when undici => 
					 --
					LED_reg_1<= "1001111";					 
					LED_reg_0<= "1001111";

                if caffe = '1' then  
                    stateMealy_next <= sei;
						  LED_out <= "0110001";
                elsif cappuccino = '1' then  
                    stateMealy_next <= cinque;
						  LED_out <= "0000010"; 
                elsif ricarica = '1' then  
                    stateMealy_next <= undici;--NON PERMESSO
						  LED_out <= "0110000";

                end if;

				when dodici => 
					 --
					LED_reg_1<= "1001111";					 
					LED_reg_0<= "0010010";

                if caffe = '1' then  
                    stateMealy_next <= sette;
						  LED_out <= "0110001";
                elsif cappuccino = '1' then  
                    stateMealy_next <= sei;
						  LED_out <= "0000010"; 
                elsif ricarica = '1' then  
                    stateMealy_next <= dodici;--NON PERMESSO
						  LED_out <= "0110000";
                end if;

				when tredici => 
					 --
					LED_reg_1<= "1001111";					 
					LED_reg_0<= "0000110";

                if caffe = '1' then  
                    stateMealy_next <= otto;
						  LED_out <= "0110001";
                elsif cappuccino = '1' then  
                    stateMealy_next <= sette;
						  LED_out <= "0000010"; 
                elsif ricarica = '1' then  
                    stateMealy_next <= tredici;--NON PERMESSO
						  LED_out <= "0110000";
                end if;

				when quattordici => 
					 --
					LED_reg_1<= "1001111";					 
					LED_reg_0<= "1001100";

                if caffe = '1' then  
                    stateMealy_next <= nove;
						  LED_out <= "0110001";
                elsif cappuccino = '1' then  
                    stateMealy_next <= otto; 
						  LED_out <= "0000010";
                elsif ricarica = '1' then  
                    stateMealy_next <= quattordici;--NON PERMESSO
						  LED_out <= "0110000";
                end if;

				when quindici => 
					 --
					LED_reg_1<= "1001111";					 
					LED_reg_0<= "0100100";

                if caffe = '1' then  
                    stateMealy_next <= dieci;
						  LED_out <= "0110001";
                elsif cappuccino = '1' then  
                    stateMealy_next <= nove; 
						  LED_out <= "0000010";
                elsif ricarica = '1' then  
                    stateMealy_next <= quindici;--NON PERMESSO
						  LED_out <= "0110000";
                end if;
            
        end case;
            
		  end if;
		  
		end process;  
		process(stateMealy_next)
		begin 	
        
        case stateMealy_next is 
            
		 when zero => 
					LED_next_1<= "0000001";
					LED_next_0<= "0000001";
					 
				when uno => 
					 --
					LED_next_1<= "0000001";
					LED_next_0<= "1001111";
					
				when due => 
					 --
					LED_next_1<= "0000001";
					LED_next_0<= "0010010";

				when tre => 
					 --
					LED_next_1<= "0000001";
					LED_next_0<= "0000110";

				when quattro => 
					 --
					LED_next_1<= "0000001";
					LED_next_0<= "1001100";
					 
				when cinque => 
					 --
					LED_next_1<= "0000001";
					LED_next_0<= "0100100";
			
				when sei => 
					 --
					LED_next_1<= "0000001";
					LED_next_0<= "0100000";
					
				when sette => 
					 --
					LED_next_1<= "0000001";
					LED_next_0<= "0001111";
              
				when otto => 
					 --
					LED_next_1<= "0000001";
					LED_next_0<= "0000000";

				when nove => 
					 --
					LED_next_1<= "0000001";
					LED_next_0<= "0000100";

				when dieci => 
					 --
					LED_next_1<= "1001111";
					LED_next_0<= "0000001";
					
				when undici => 
					 --
					LED_next_1<= "1001111";					 
					LED_next_0<= "1001111";
               
				when dodici => 
					 --
					LED_next_1<= "1001111";					 
					LED_next_0<= "0010010";
               

				when tredici => 
					 --
					LED_next_1<= "1001111";					 
					LED_next_0<= "0000110";

				when quattordici => 
					 --
					LED_next_1<= "1001111";					 
					LED_next_0<= "1001100";

				when quindici => 
					 --
					LED_next_1<= "1001111";					 
					LED_next_0<= "0100100";
            
        end case; 
		end process;  
end arch; 