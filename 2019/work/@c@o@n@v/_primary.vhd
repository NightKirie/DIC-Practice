library verilog;
use verilog.vl_types.all;
entity CONV is
    generic(
        NO_MEM_SEL      : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        RW_LAYER0       : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        RW_LAYER1       : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        \WAIT\          : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        LOAD            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        CONVOLUTION     : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        RELU            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        MAXPOOL         : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        ker0            : vl_logic_vector(0 to 19) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0);
        ker1            : vl_logic_vector(0 to 19) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi1);
        ker2            : vl_logic_vector(0 to 19) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        ker3            : vl_logic_vector(0 to 19) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        ker4            : vl_logic_vector(0 to 19) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi0, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi1);
        ker5            : vl_logic_vector(0 to 19) := (Hi1, Hi1, Hi1, Hi1, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0);
        ker6            : vl_logic_vector(0 to 19) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi1, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi1, Hi1);
        ker7            : vl_logic_vector(0 to 19) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0, Hi0);
        ker8            : vl_logic_vector(0 to 19) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi1);
        bias            : vl_logic_vector(0 to 39) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
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
    attribute mti_svvh_generic_type of CONVOLUTION : constant is 1;
    attribute mti_svvh_generic_type of RELU : constant is 1;
    attribute mti_svvh_generic_type of MAXPOOL : constant is 1;
    attribute mti_svvh_generic_type of ker0 : constant is 1;
    attribute mti_svvh_generic_type of ker1 : constant is 1;
    attribute mti_svvh_generic_type of ker2 : constant is 1;
    attribute mti_svvh_generic_type of ker3 : constant is 1;
    attribute mti_svvh_generic_type of ker4 : constant is 1;
    attribute mti_svvh_generic_type of ker5 : constant is 1;
    attribute mti_svvh_generic_type of ker6 : constant is 1;
    attribute mti_svvh_generic_type of ker7 : constant is 1;
    attribute mti_svvh_generic_type of ker8 : constant is 1;
    attribute mti_svvh_generic_type of bias : constant is 1;
end CONV;
