library verilog;
use verilog.vl_types.all;
entity LCD_CTRL is
    generic(
        Input           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        Command         : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        Output          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        Write           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        Shift_Up        : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        Shift_Down      : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        Shift_Left      : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        Shift_Right     : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        Average         : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        Mirror_X        : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0);
        Mirror_Y        : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1)
    );
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
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Input : constant is 1;
    attribute mti_svvh_generic_type of Command : constant is 1;
    attribute mti_svvh_generic_type of Output : constant is 1;
    attribute mti_svvh_generic_type of Write : constant is 1;
    attribute mti_svvh_generic_type of Shift_Up : constant is 1;
    attribute mti_svvh_generic_type of Shift_Down : constant is 1;
    attribute mti_svvh_generic_type of Shift_Left : constant is 1;
    attribute mti_svvh_generic_type of Shift_Right : constant is 1;
    attribute mti_svvh_generic_type of Average : constant is 1;
    attribute mti_svvh_generic_type of Mirror_X : constant is 1;
    attribute mti_svvh_generic_type of Mirror_Y : constant is 1;
end LCD_CTRL;
