library verilog;
use verilog.vl_types.all;
entity SME is
    generic(
        INPUT           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        STORE_LENGTH    : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        COUNT_BEGIN_DOT : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        COUNT_END_DOT   : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        COMPARE         : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        OUTPUT          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        BEGIN_END       : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        \BEGIN\         : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        \END\           : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        NONE            : vl_logic_vector(0 to 1) := (Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        chardata        : in     vl_logic_vector(7 downto 0);
        isstring        : in     vl_logic;
        ispattern       : in     vl_logic;
        valid           : out    vl_logic;
        match           : out    vl_logic;
        match_index     : out    vl_logic_vector(4 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INPUT : constant is 1;
    attribute mti_svvh_generic_type of STORE_LENGTH : constant is 1;
    attribute mti_svvh_generic_type of COUNT_BEGIN_DOT : constant is 1;
    attribute mti_svvh_generic_type of COUNT_END_DOT : constant is 1;
    attribute mti_svvh_generic_type of COMPARE : constant is 1;
    attribute mti_svvh_generic_type of OUTPUT : constant is 1;
    attribute mti_svvh_generic_type of BEGIN_END : constant is 1;
    attribute mti_svvh_generic_type of \BEGIN\ : constant is 1;
    attribute mti_svvh_generic_type of \END\ : constant is 1;
    attribute mti_svvh_generic_type of NONE : constant is 1;
end SME;
