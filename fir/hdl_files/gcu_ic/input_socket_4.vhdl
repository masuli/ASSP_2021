library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity toplevel_input_socket_cons_4 is

  generic (
    BUSW_0 : integer := 32;
    BUSW_1 : integer := 32;
    BUSW_2 : integer := 32;
    BUSW_3 : integer := 32;
    DATAW : integer := 32);
  port (
    databus0 : in std_logic_vector(BUSW_0-1 downto 0);
    databus1 : in std_logic_vector(BUSW_1-1 downto 0);
    databus2 : in std_logic_vector(BUSW_2-1 downto 0);
    databus3 : in std_logic_vector(BUSW_3-1 downto 0);
    data : out std_logic_vector(DATAW-1 downto 0);
    databus_cntrl : in std_logic_vector(1 downto 0));

end toplevel_input_socket_cons_4;

architecture input_socket of toplevel_input_socket_cons_4 is
begin

    -- If width of input bus is greater than width of output,
    -- using the LSB bits.
    -- If width of input bus is smaller than width of output,
    -- using zero extension to generate extra bits.

  sel : process (databus_cntrl, databus0, databus1, databus2, databus3)
  begin
    case databus_cntrl is
      when "00" =>
        if BUSW_0 < DATAW then
          data <= ext(databus0,data'length);
        elsif BUSW_0 > DATAW then
          data <= databus0(DATAW-1 downto 0);
        else
          data <= databus0(BUSW_0-1 downto 0);
        end if;
      when "01" =>
        if BUSW_1 < DATAW then
          data <= ext(databus1,data'length);
        elsif BUSW_1 > DATAW then
          data <= databus1(DATAW-1 downto 0);
        else
          data <= databus1(BUSW_1-1 downto 0);
        end if;
      when "10" =>
        if BUSW_2 < DATAW then
          data <= ext(databus2,data'length);
        elsif BUSW_2 > DATAW then
          data <= databus2(DATAW-1 downto 0);
        else
          data <= databus2(BUSW_2-1 downto 0);
        end if;
      when others =>
        if BUSW_3 < DATAW then
          data <= ext(databus3,data'length);
        elsif BUSW_3 > DATAW then
          data <= databus3(DATAW-1 downto 0);
        else
          data <= databus3(BUSW_3-1 downto 0);
        end if;
    end case;
  end process sel;
end input_socket;
