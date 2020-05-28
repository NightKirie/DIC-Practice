library verilog;
use verilog.vl_types.all;
entity GPSDC is
    generic(
        rad             : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi1, Hi1, Hi1);
        R               : vl_logic_vector(0 to 23) := (Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0);
        LOAD_1          : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        LOAD_2          : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        GET_SIN         : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1)
    );
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
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of rad : constant is 1;
    attribute mti_svvh_generic_type of R : constant is 1;
    attribute mti_svvh_generic_type of LOAD_1 : constant is 1;
    attribute mti_svvh_generic_type of LOAD_2 : constant is 1;
    attribute mti_svvh_generic_type of GET_SIN : constant is 1;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
end GPSDC;
