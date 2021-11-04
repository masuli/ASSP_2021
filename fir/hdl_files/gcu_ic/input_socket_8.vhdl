library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity toplevel_input_socket_cons_8 is

  generic (
    BUSW_0 : integer := 32;
    BUSW_1 : integer := 32;
    BUSW_2 : integer := 32;
    BUSW_3 : integer := 32;
    BUSW_4 : integer := 32;
    BUSW_5 : integer := 32;
    BUSW_6 : integer := 32;
    BUSW_7 : integer := 32;
    DATAW : integer := 32);
  port (
    databus0 : in std_logic_vector(BUSW_0-1 downto 0);
    databus1 : in std_logic_vector(BUSW_1-1 downto 0);
    databus2 : in std_logic_vector(BUSW_2-1 downto 0);
    databus3 : in std_logic_vector(BUSW_3-1 downto 0);
    databus4 : in std_logic_vector(BUSW_4-1 downto 0);
    databus5 : in std_logic_vector(BUSW_5-1 downto 0);
    databus6 : in std_logic_vector(BUSW_6-1 downto 0);
    databus7 : in std_logic_vector(BUSW_7-1 downto 0);
    data : out std_logic_vector(DATAW-1 downto 0);
    databus_cntrl : in std_logic_vector(2 downto 0));

end toplevel_input_socket_cons_8;

architecture input_socket of toplevel_input_socket_cons_8 is
begin

    -- If width of input bus is greater than width of output,
    -- using the LSB bits.
    -- If width of input bus is smaller than width of output,
    -- using zero extension to generate extra bits.

  sel : process (databus_cntrl, databus0, databus1, databus2, databus3, databus4, databus5, databus6, databus7)
  begin
    case databus_cntrl is
      when "000" =>
        if BUSW_0 < DATAW then
          data <= ext(databus0,data'length);
        elsif BUSW_0 > DATAW then
          data <= databus0(DATAW-1 downto 0);
        else
          data <= databus0(BUSW_0-1 downto 0);
        end if;
      when "001" =>
        if BUSW_1 < DATAW then
          data <= ext(databus1,data'length);
        elsif BUSW_1 > DATAW then
          data <= databus1(DATAW-1 downto 0);
        else
          data <= databus1(BUSW_1-1 downto 0);
        end if;
      when "010" =>
        if BUSW_2 < DATAW then
          data <= ext(databus2,data'length);
        elsif BUSW_2 > DATAW then
          data <= databus2(DATAW-1 downto 0);
        else
          data <= databus2(BUSW_2-1 downto 0);
        end if;
      when "011" =>
        if BUSW_3 < DATAW then
          data <= ext(databus3,data'length);
        elsif BUSW_3 > DATAW then
          data <= databus3(DATAW-1 downto 0);
        else
          data <= databus3(BUSW_3-1 downto 0);
        end if;
      when "100" =>
        if BUSW_4 < DATAW then
          data <= ext(databus4,data'length);
        elsif BUSW_4 > DATAW then
          data <= databus4(DATAW-1 downto 0);
        else
          data <= databus4(BUSW_4-1 downto 0);
        end if;
      when "101" =>
        if BUSW_5 < DATAW then
          data <= ext(databus5,data'length);
        elsif BUSW_5 > DATAW then
          data <= databus5(DATAW-1 downto 0);
        else
          data <= databus5(BUSW_5-1 downto 0);
        end if;
      when "110" =>
        if BUSW_6 < DATAW then
          data <= ext(databus6,data'length);
        elsif BUSW_6 > DATAW then
          data <= databus6(DATAW-1 downto 0);
        else
          data <= databus6(BUSW_6-1 downto 0);
        end if;
      when others =>
        if BUSW_7 < DATAW then
          data <= ext(databus7,data'length);
        elsif BUSW_7 > DATAW then
          data <= databus7(DATAW-1 downto 0);
        else
          data <= databus7(BUSW_7-1 downto 0);
        end if;
    end case;
  end process sel;
end input_socket;
