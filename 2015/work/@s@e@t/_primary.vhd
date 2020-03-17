library verilog;
use verilog.vl_types.all;
entity SET is
    generic(
        \WAIT\          : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        INPUT           : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        COMPARE         : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        OUTPUT          : vl_logic_vector(0 to 1) := (Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        en              : in     vl_logic;
        central         : in     vl_logic_vector(23 downto 0);
        radius          : in     vl_logic_vector(11 downto 0);
        mode            : in     vl_logic_vector(1 downto 0);
        busy            : out    vl_logic;
        valid           : out    vl_logic;
        candidate       : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of \WAIT\ : constant is 1;
    attribute mti_svvh_generic_type of INPUT : constant is 1;
    attribute mti_svvh_generic_type of COMPARE : constant is 1;
    attribute mti_svvh_generic_type of OUTPUT : constant is 1;
end SET;
