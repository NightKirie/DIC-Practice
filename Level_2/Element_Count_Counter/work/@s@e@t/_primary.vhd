library verilog;
use verilog.vl_types.all;
entity SET is
    generic(
        Input           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        Cal_Radius      : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        Cal_Distance    : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        Compare         : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        Output          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
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
    attribute mti_svvh_generic_type of Input : constant is 1;
    attribute mti_svvh_generic_type of Cal_Radius : constant is 1;
    attribute mti_svvh_generic_type of Cal_Distance : constant is 1;
    attribute mti_svvh_generic_type of Compare : constant is 1;
    attribute mti_svvh_generic_type of Output : constant is 1;
end SET;
