library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
entity exchangeSignedIntToOffSetBinary is
	port (SignedInt: in std_logic_vector (7 downto 0);
			OffSetBinary: out std_logic_vector(7 downto 0)) ;
end exchangeSignedIntToOffSetBinary;
architecture arc_exchangeSignedIntToOffSetBinary of exchangeSignedIntToOffSetBinary is
begin
	OffSetBinary(7)<= not(SignedInt(7));
	OffSetBinary(6 downto 0)<= SignedInt( 6 downto 0);
end arc_exchangeSignedIntToOffSetBinary;