library verilog;
use verilog.vl_types.all;
entity CONV is
    generic(
        NO_MEM_SEL      : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        RW_LAYER0       : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        RW_LAYER1       : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        \WAIT\          : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        LOAD            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        LAYER0          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        ready           : in     vl_logic;
        idata           : in     vl_logic_vector(19 downto 0);
        cdata_rd        : in     vl_logic_vector(19 downto 0);
        busy            : out    vl_logic;
        iaddr           : out    vl_logic_vector(11 downto 0);
        cwr             : out    vl_logic;
        caddr_wr        : out    vl_logic_vector(11 downto 0);
        cdata_wr        : out    vl_logic_vector(19 downto 0);
        crd             : out    vl_logic;
        caddr_rd        : out    vl_logic_vector(11 downto 0);
        csel            : out    vl_logic_vector(2 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NO_MEM_SEL : constant is 1;
    attribute mti_svvh_generic_type of RW_LAYER0 : constant is 1;
    attribute mti_svvh_generic_type of RW_LAYER1 : constant is 1;
    attribute mti_svvh_generic_type of \WAIT\ : constant is 1;
    attribute mti_svvh_generic_type of LOAD : constant is 1;
    attribute mti_svvh_generic_type of LAYER0 : constant is 1;
end CONV;
