library verilog;
use verilog.vl_types.all;
entity LCD_CTRL is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        IROM_Q          : in     vl_logic_vector(7 downto 0);
        cmd             : in     vl_logic_vector(2 downto 0);
        cmd_valid       : in     vl_logic;
        IROM_EN         : out    vl_logic;
        IROM_A          : out    vl_logic_vector(5 downto 0);
        IRB_RW          : out    vl_logic;
        IRB_D           : out    vl_logic_vector(7 downto 0);
        IRB_A           : out    vl_logic_vector(5 downto 0);
        busy            : out    vl_logic;
        done            : out    vl_logic
    );
end LCD_CTRL;
