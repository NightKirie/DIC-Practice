library verilog;
use verilog.vl_types.all;
entity triangle is
    generic(
        Idle            : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        Input           : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        Output          : vl_logic_vector(0 to 1) := (Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        nt              : in     vl_logic;
        xi              : in     vl_logic_vector(2 downto 0);
        yi              : in     vl_logic_vector(2 downto 0);
        busy            : out    vl_logic;
        po              : out    vl_logic;
        xo              : out    vl_logic_vector(2 downto 0);
        yo              : out    vl_logic_vector(2 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Idle : constant is 1;
    attribute mti_svvh_generic_type of Input : constant is 1;
    attribute mti_svvh_generic_type of Output : constant is 1;
end triangle;
