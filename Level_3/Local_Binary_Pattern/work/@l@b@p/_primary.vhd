library verilog;
use verilog.vl_types.all;
entity LBP is
    generic(
        LOAD            : integer := 0;
        OUTPUT          : integer := 1
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        gray_addr       : out    vl_logic_vector(13 downto 0);
        gray_req        : out    vl_logic;
        gray_ready      : in     vl_logic;
        gray_data       : in     vl_logic_vector(7 downto 0);
        lbp_addr        : out    vl_logic_vector(13 downto 0);
        lbp_valid       : out    vl_logic;
        lbp_data        : out    vl_logic_vector(7 downto 0);
        finish          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LOAD : constant is 1;
    attribute mti_svvh_generic_type of OUTPUT : constant is 1;
end LBP;
