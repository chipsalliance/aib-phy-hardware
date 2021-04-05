module emib_ch (
	inout [101:0] s_aib,
	inout [101:0] m_aib

	);

genvar i;

generate
  for (i=0; i<102; i=i+1) begin: aib_io_conn
  aliasv xaliasv95 (
	.PLUS(m_aib[i]),
	.MINUS(s_aib[101-i])
  );
  end
endgenerate

endmodule
