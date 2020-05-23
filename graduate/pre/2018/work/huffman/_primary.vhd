library verilog;
use verilog.vl_types.all;
entity huffman is
    generic(
        LOAD            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        CAL_HUFFMAN     : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        gray_valid      : in     vl_logic;
        gray_data       : in     vl_logic_vector(7 downto 0);
        CNT_valid       : out    vl_logic;
        CNT1            : out    vl_logic_vector(7 downto 0);
        CNT2            : out    vl_logic_vector(7 downto 0);
        CNT3            : out    vl_logic_vector(7 downto 0);
        CNT4            : out    vl_logic_vector(7 downto 0);
        CNT5            : out    vl_logic_vector(7 downto 0);
        CNT6            : out    vl_logic_vector(7 downto 0);
        code_valid      : out    vl_logic;
        HC1             : out    vl_logic_vector(7 downto 0);
        HC2             : out    vl_logic_vector(7 downto 0);
        HC3             : out    vl_logic_vector(7 downto 0);
        HC4             : out    vl_logic_vector(7 downto 0);
        HC5             : out    vl_logic_vector(7 downto 0);
        HC6             : out    vl_logic_vector(7 downto 0);
        M1              : out    vl_logic_vector(7 downto 0);
        M2              : out    vl_logic_vector(7 downto 0);
        M3              : out    vl_logic_vector(7 downto 0);
        M4              : out    vl_logic_vector(7 downto 0);
        M5              : out    vl_logic_vector(7 downto 0);
        M6              : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LOAD : constant is 1;
    attribute mti_svvh_generic_type of CAL_HUFFMAN : constant is 1;
end huffman;
