library verilog;
use verilog.vl_types.all;
entity FC is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        cmd             : in     vl_logic_vector(32 downto 0);
        done            : out    vl_logic;
        M_RW            : out    vl_logic;
        M_A             : out    vl_logic_vector(6 downto 0);
        M_D             : inout  vl_logic_vector(7 downto 0);
        F_IO            : inout  vl_logic_vector(7 downto 0);
        F_CLE           : out    vl_logic;
        F_ALE           : out    vl_logic;
        F_REN           : out    vl_logic;
        F_WEN           : out    vl_logic;
        F_RB            : in     vl_logic
    );
end FC;
