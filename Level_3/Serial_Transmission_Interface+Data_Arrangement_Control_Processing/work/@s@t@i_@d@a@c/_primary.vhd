library verilog;
use verilog.vl_types.all;
entity STI_DAC is
    generic(
        \WAIT\          : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        \LOAD\          : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        SO_OUT          : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        FILL_PIXEL      : vl_logic_vector(0 to 1) := (Hi1, Hi1);
        Bit_8           : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        Bit_16          : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        Bit_24          : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        Bit_32          : vl_logic_vector(0 to 1) := (Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        load            : in     vl_logic;
        pi_data         : in     vl_logic_vector(15 downto 0);
        pi_length       : in     vl_logic_vector(1 downto 0);
        pi_fill         : in     vl_logic;
        pi_msb          : in     vl_logic;
        pi_low          : in     vl_logic;
        pi_end          : in     vl_logic;
        so_data         : out    vl_logic;
        so_valid        : out    vl_logic;
        pixel_finish    : out    vl_logic;
        pixel_dataout   : out    vl_logic_vector(7 downto 0);
        pixel_addr      : out    vl_logic_vector(7 downto 0);
        pixel_wr        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of \WAIT\ : constant is 1;
    attribute mti_svvh_generic_type of \LOAD\ : constant is 1;
    attribute mti_svvh_generic_type of SO_OUT : constant is 1;
    attribute mti_svvh_generic_type of FILL_PIXEL : constant is 1;
    attribute mti_svvh_generic_type of Bit_8 : constant is 1;
    attribute mti_svvh_generic_type of Bit_16 : constant is 1;
    attribute mti_svvh_generic_type of Bit_24 : constant is 1;
    attribute mti_svvh_generic_type of Bit_32 : constant is 1;
end STI_DAC;
