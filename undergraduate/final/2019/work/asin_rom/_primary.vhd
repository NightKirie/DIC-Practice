library verilog;
use verilog.vl_types.all;
entity asin_rom is
    port(
        addr            : in     vl_logic_vector(5 downto 0);
        data            : out    vl_logic_vector(127 downto 0)
    );
end asin_rom;
