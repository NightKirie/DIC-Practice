library verilog;
use verilog.vl_types.all;
entity FAS is
    generic(
        LOAD            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        CAL_FFT         : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data_valid      : in     vl_logic;
        data            : in     vl_logic_vector(15 downto 0);
        fft_d0          : out    vl_logic_vector(31 downto 0);
        fft_d1          : out    vl_logic_vector(31 downto 0);
        fft_d2          : out    vl_logic_vector(31 downto 0);
        fft_d3          : out    vl_logic_vector(31 downto 0);
        fft_d4          : out    vl_logic_vector(31 downto 0);
        fft_d5          : out    vl_logic_vector(31 downto 0);
        fft_d6          : out    vl_logic_vector(31 downto 0);
        fft_d7          : out    vl_logic_vector(31 downto 0);
        fft_d8          : out    vl_logic_vector(31 downto 0);
        fft_d9          : out    vl_logic_vector(31 downto 0);
        fft_d10         : out    vl_logic_vector(31 downto 0);
        fft_d11         : out    vl_logic_vector(31 downto 0);
        fft_d12         : out    vl_logic_vector(31 downto 0);
        fft_d13         : out    vl_logic_vector(31 downto 0);
        fft_d14         : out    vl_logic_vector(31 downto 0);
        fft_d15         : out    vl_logic_vector(31 downto 0);
        fft_valid       : out    vl_logic;
        done            : out    vl_logic;
        freq            : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LOAD : constant is 1;
    attribute mti_svvh_generic_type of CAL_FFT : constant is 1;
end FAS;
