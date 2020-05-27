library verilog;
use verilog.vl_types.all;
entity TPA is
    generic(
        TWP_WAIT        : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        TWP_CMD         : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        TWP_WRITE_ADDR  : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        TWP_WRITE_DATA  : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        TWP_READ_ADDR   : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        TWP_READ_SET_TAR: vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        TWP_READ_DATA   : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0);
        TWP_READ_ZERO_TAR: vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        SCL             : in     vl_logic;
        SDA             : inout  vl_logic;
        cfg_req         : in     vl_logic;
        cfg_rdy         : out    vl_logic;
        cfg_cmd         : in     vl_logic;
        cfg_addr        : in     vl_logic_vector(7 downto 0);
        cfg_wdata       : in     vl_logic_vector(15 downto 0);
        cfg_rdata       : out    vl_logic_vector(15 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of TWP_WAIT : constant is 1;
    attribute mti_svvh_generic_type of TWP_CMD : constant is 1;
    attribute mti_svvh_generic_type of TWP_WRITE_ADDR : constant is 1;
    attribute mti_svvh_generic_type of TWP_WRITE_DATA : constant is 1;
    attribute mti_svvh_generic_type of TWP_READ_ADDR : constant is 1;
    attribute mti_svvh_generic_type of TWP_READ_SET_TAR : constant is 1;
    attribute mti_svvh_generic_type of TWP_READ_DATA : constant is 1;
    attribute mti_svvh_generic_type of TWP_READ_ZERO_TAR : constant is 1;
end TPA;
