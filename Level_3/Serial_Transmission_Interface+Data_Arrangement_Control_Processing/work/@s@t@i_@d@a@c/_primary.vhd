library verilog;
use verilog.vl_types.all;
entity STI_DAC is
    generic(
        SAVE            : vl_logic_vector(2 downto 0) := (Hi0, Hi0, Hi0);
        \WAIT\          : vl_logic_vector(2 downto 0) := (Hi0, Hi0, Hi1);
        \IN\            : vl_logic_vector(2 downto 0) := (Hi0, Hi1, Hi0);
        MEM             : vl_logic_vector(2 downto 0) := (Hi0, Hi1, Hi1);
        OUT8            : vl_logic_vector(2 downto 0) := (Hi1, Hi0, Hi0);
        OUT16           : vl_logic_vector(2 downto 0) := (Hi1, Hi0, Hi1);
        OUT24           : vl_logic_vector(2 downto 0) := (Hi1, Hi1, Hi0);
        OUT32           : vl_logic_vector(2 downto 0) := (Hi1, Hi1, Hi1)
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
    attribute mti_svvh_generic_type of SAVE : constant is 2;
    attribute mti_svvh_generic_type of \WAIT\ : constant is 2;
    attribute mti_svvh_generic_type of \IN\ : constant is 2;
    attribute mti_svvh_generic_type of MEM : constant is 2;
    attribute mti_svvh_generic_type of OUT8 : constant is 2;
    attribute mti_svvh_generic_type of OUT16 : constant is 2;
    attribute mti_svvh_generic_type of OUT24 : constant is 2;
    attribute mti_svvh_generic_type of OUT32 : constant is 2;
end STI_DAC;
