library verilog;
use verilog.vl_types.all;
entity GPSDC is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        DEN             : in     vl_logic;
        LON_IN          : in     vl_logic_vector(23 downto 0);
        LAT_IN          : in     vl_logic_vector(23 downto 0);
        COS_ADDR        : out    vl_logic_vector(6 downto 0);
        COS_DATA        : in     vl_logic_vector(95 downto 0);
        ASIN_ADDR       : out    vl_logic_vector(5 downto 0);
        ASIN_DATA       : in     vl_logic_vector(127 downto 0);
        Valid           : out    vl_logic;
        a               : out    vl_logic_vector(63 downto 0);
        D               : out    vl_logic_vector(39 downto 0)
    );
end GPSDC;
