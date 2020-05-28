library verilog;
use verilog.vl_types.all;
entity cos_rom is
    port(
        addr            : in     vl_logic_vector(6 downto 0);
        data            : out    vl_logic_vector(95 downto 0)
    );
end cos_rom;
