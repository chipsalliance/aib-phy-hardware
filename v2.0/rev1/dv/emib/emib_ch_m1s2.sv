module emib_ch_m1s2 (
	inout [95:0] m_aib,
	inout [101:0] s_aib

	);

wire tie_low = 1'b0;
wire tie_hi = 1'b1;

  aliasv xaliasv101 (
	.MINUS(s_aib[101]),
	.PLUS()
  );


  aliasv xaliasv100 (
	.MINUS(s_aib[100]),
	.PLUS()
  );

  aliasv xaliasv99 (
	.MINUS(s_aib[99]),
	.PLUS()
  );

  aliasv xaliasv98 (
	.MINUS(s_aib[98]),
	.PLUS()
  );


  aliasv xaliasv97 (
	.MINUS(s_aib[97]),
	.PLUS()
  );

  aliasv xaliasv96 (
	.MINUS(s_aib[96]),
	.PLUS()
  );

  aliasv xaliasv95 (
	.MINUS(s_aib[95]),
	.PLUS()
  );

  aliasv xaliasv94 (
	.MINUS(s_aib[94]),
	.PLUS()
  );

  aliasv xaliasv93 (
	.MINUS(s_aib[93]),
	.PLUS()
  );

  aliasv xaliasv92 (
	.MINUS(s_aib[92]),
	.PLUS()
  );

  aliasv xaliasv91 (
	.MINUS(s_aib[91]),
	.PLUS()
  );

  aliasv xaliasv90 (
	.MINUS(s_aib[90]),
	.PLUS()
  );

  aliasv xaliasv89 (
	.MINUS(s_aib[89]),
	.PLUS()
  );

  aliasv xaliasv88 (
	.MINUS(s_aib[88]),
	.PLUS()
  );

  aliasv xaliasv87 (
	.MINUS(s_aib[87]),
	.PLUS()
  );

  aliasv xaliasv86 (
	.MINUS(s_aib[86]),
	.PLUS()
  );

  aliasv xaliasv85 (
	.MINUS(s_aib[85]),
	.PLUS()
  );

  aliasv xaliasv84 (
	.MINUS(s_aib[84]),
	.PLUS()
  );

  aliasv xaliasv83 (
	.MINUS(s_aib[83]),
	.PLUS()
  );

  aliasv xaliasv82 (
	.MINUS(s_aib[82]),
	.PLUS()
  );

  aliasv xaliasv81 (
	.MINUS(s_aib[81]),
	.PLUS(m_aib[18])
  );

  aliasv xaliasv80 (
	.MINUS(s_aib[80]),
	.PLUS(m_aib[19])
  );

  aliasv xaliasv79 (
	.MINUS(s_aib[79]),
	.PLUS(m_aib[16])
  );

  aliasv xaliasv78 (
	.MINUS(s_aib[78]),
	.PLUS(m_aib[17])
  );

  aliasv xaliasv77 (
	.MINUS(s_aib[77]),
	.PLUS(m_aib[14])
  );

  aliasv xaliasv76 (
	.MINUS(s_aib[76]),
	.PLUS(m_aib[15])
  );

  aliasv xaliasv75 (
	.MINUS(s_aib[75]),
	.PLUS(m_aib[12])
  );

  aliasv xaliasv74 (
	.MINUS(s_aib[74]),
	.PLUS(m_aib[13])
  );

  aliasv xaliasv73 (
	.MINUS(s_aib[73]),
	.PLUS(m_aib[10])
  );

  aliasv xaliasv72 (
	.MINUS(s_aib[72]),
	.PLUS(m_aib[11])
  );

  aliasv xaliasv71 (
	.MINUS(s_aib[71]),
	.PLUS(m_aib[41])
  );

  aliasv xaliasv70 (
	.MINUS(s_aib[70]),
	.PLUS(m_aib[40])
  );

  aliasv xaliasv69 (
	.MINUS(s_aib[69]),
	.PLUS(m_aib[8])
  );

  aliasv xaliasv68 (
	.MINUS(s_aib[68]),
	.PLUS(m_aib[9])
  );

  aliasv xaliasv67 (
	.MINUS(s_aib[67]),
	.PLUS(m_aib[6])
  );

  aliasv xaliasv66 (
	.MINUS(s_aib[66]),
	.PLUS(m_aib[7])
  );

  aliasv xaliasv65 (
	.MINUS(s_aib[65]),
	.PLUS(m_aib[4])
  );

  aliasv xaliasv64 (
	.MINUS(s_aib[64]),
	.PLUS(m_aib[5])
  );

  aliasv xaliasv63 (
	.MINUS(s_aib[63]),
	.PLUS(m_aib[2])
  );

  aliasv xaliasv62 (
	.MINUS(s_aib[62]),
	.PLUS(m_aib[3])
  );

  aliasv xaliasv61 (
	.MINUS(s_aib[61]),
	.PLUS(m_aib[0])
  );

  aliasv xaliasv60 (
	.MINUS(s_aib[60]),
	.PLUS(m_aib[1])
  );

  aliasv xaliasv59 (
	.MINUS(s_aib[59]),
	.PLUS(m_aib[87])
  );

  aliasv xaliasv58 (
	.MINUS(s_aib[58]),
	.PLUS(m_aib[86])
  );

  aliasv xaliasv57 (
	.MINUS(s_aib[57]),
	.PLUS(m_aib[85])
  );

  aliasv xaliasv56 (
	.MINUS(s_aib[56]),
	.PLUS(m_aib[84])
  );

  aliasv xaliasv55 (
	.MINUS(s_aib[55]),
	.PLUS(m_aib[95])
  );

  aliasv xaliasv54 (
	.MINUS(s_aib[54]),
	.PLUS(m_aib[94])
  );

  aliasv xaliasv53 (
	.MINUS(s_aib[53]),
	.PLUS(m_aib[49])
  );

  aliasv xaliasv52 (
	.MINUS(s_aib[52]),
	.PLUS(m_aib[56])
  );

  aliasv xaliasv51 (
	.MINUS(s_aib[51]),
	.PLUS()
  );

  aliasv xaliasv50 (
	.MINUS(s_aib[50]),
	.PLUS()
  );

  aliasv xaliasv49 (
	.MINUS(s_aib[49]),
	.PLUS(m_aib[65])
  );

  aliasv xaliasv48 (
	.MINUS(s_aib[48]),
	.PLUS(m_aib[44])
  );

  aliasv xaliasv47 (
	.MINUS(s_aib[47]),
	.PLUS(m_aib[92])
  );

  aliasv xaliasv46 (
	.MINUS(s_aib[46]),
	.PLUS(m_aib[93])
  );

  aliasv xaliasv45 (
	.MINUS(s_aib[45]),
	.PLUS(m_aib[82])
  );

  aliasv xaliasv44 (
	.MINUS(s_aib[44]),
	.PLUS(m_aib[83])
  );

  aliasv xaliasv43 (
	.MINUS(s_aib[43]),
	.PLUS(m_aib[59])
  );

  aliasv xaliasv42 (
	.MINUS(s_aib[42]),
	.PLUS(m_aib[57])
  );

  aliasv xaliasv41 (
	.MINUS(s_aib[41]),
	.PLUS(m_aib[21])
  );

  aliasv xaliasv40 (
	.MINUS(s_aib[40]),
	.PLUS(m_aib[20])
  );

  aliasv xaliasv39 (
	.MINUS(s_aib[39]),
	.PLUS(m_aib[23])
  );

  aliasv xaliasv38 (
	.MINUS(s_aib[38]),
	.PLUS(m_aib[22])
  );

  aliasv xaliasv37 (
	.MINUS(s_aib[37]),
	.PLUS(m_aib[25])
  );

  aliasv xaliasv36 (
	.MINUS(s_aib[36]),
	.PLUS(m_aib[24])
  );

  aliasv xaliasv35 (
	.MINUS(s_aib[35]),
	.PLUS(m_aib[27])
  );

  aliasv xaliasv34 (
	.MINUS(s_aib[34]),
	.PLUS(m_aib[26])
  );

  aliasv xaliasv33 (
	.MINUS(s_aib[33]),
	.PLUS(m_aib[29])
  );

  aliasv xaliasv32 (
	.MINUS(s_aib[32]),
	.PLUS(m_aib[28])
  );

  aliasv xaliasv31 (
	.MINUS(s_aib[31]),
	.PLUS(m_aib[42])
  );

  aliasv xaliasv30 (
	.MINUS(s_aib[30]),
	.PLUS(m_aib[43])
  );

  aliasv xaliasv29 (
	.MINUS(s_aib[29]),
	.PLUS(m_aib[31])
  );

  aliasv xaliasv28 (
	.MINUS(s_aib[28]),
	.PLUS(m_aib[30])
  );

  aliasv xaliasv27 (
	.MINUS(s_aib[27]),
	.PLUS(m_aib[33])
  );

  aliasv xaliasv26 (
	.MINUS(s_aib[26]),
	.PLUS(m_aib[32])
  );

  aliasv xaliasv25 (
	.MINUS(s_aib[25]),
	.PLUS(m_aib[35])
  );

  aliasv xaliasv24 (
	.MINUS(s_aib[24]),
	.PLUS(m_aib[34])
  );

  aliasv xaliasv23 (
	.MINUS(s_aib[23]),
	.PLUS(m_aib[37])
  );

  aliasv xaliasv22 (
	.MINUS(s_aib[22]),
	.PLUS(m_aib[36])
  );

  aliasv xaliasv21 (
	.MINUS(s_aib[21]),
	.PLUS(m_aib[39])
  );

  aliasv xaliasv20 (
	.MINUS(s_aib[20]),
	.PLUS(m_aib[38])
  );

  aliasv xaliasv19 (
	.MINUS(s_aib[19]),
	.PLUS()
  );

  aliasv xaliasv18 (
	.MINUS(s_aib[18]),
	.PLUS()
  );

  aliasv xaliasv17 (
	.MINUS(s_aib[17]),
	.PLUS()
  );

  aliasv xaliasv16 (
	.MINUS(s_aib[16]),
	.PLUS()
  );

  aliasv xaliasv15 (
	.MINUS(s_aib[15]),
	.PLUS()
  );

  aliasv xaliasv14 (
	.MINUS(s_aib[14]),
	.PLUS()
  );

  aliasv xaliasv13 (
	.MINUS(s_aib[13]),
	.PLUS()
  );

  aliasv xaliasv12 (
	.MINUS(s_aib[12]),
	.PLUS()
  );

  aliasv xaliasv11 (
	.MINUS(s_aib[11]),
	.PLUS()
  );

  aliasv xaliasv10 (
	.MINUS(s_aib[10]),
	.PLUS()
  );

  aliasv xaliasv9 (
	.MINUS(s_aib[9]),
	.PLUS()
  );

  aliasv xaliasv8 (
	.MINUS(s_aib[8]),
	.PLUS()
  );

  aliasv xaliasv7 (
	.MINUS(s_aib[7]),
	.PLUS()
  );

  aliasv xaliasv6 (
	.MINUS(s_aib[6]),
	.PLUS()
  );

  aliasv xaliasv5 (
	.MINUS(s_aib[5]),
	.PLUS()
  );

  aliasv xaliasv4 (
	.MINUS(s_aib[4]),
	.PLUS()
  );

  aliasv xaliasv3 (
	.MINUS(s_aib[3]),
	.PLUS()
  );

  aliasv xaliasv2 (
	.MINUS(s_aib[2]),
	.PLUS()
  );

  aliasv xaliasv1 (
	.MINUS(s_aib[1]),
	.PLUS()
  );

  aliasv xaliasv0 (
	.MINUS(s_aib[0]),
	.PLUS()
  );

//Unused pin of Gen1 Master AIB
  aliasv xalias_ms45 (
        .MINUS(tie_low),
        .PLUS(m_aib[45])
  );

  aliasv xalias_ms58 (
        .MINUS(tie_low),
        .PLUS(m_aib[58])
  );


  aliasv xalias_ms61 (
        .MINUS(tie_hi),
        .PLUS(m_aib[61])
  );

  aliasv xalias_ms63 (
        .MINUS(tie_low),
        .PLUS(m_aib[63])
  );

  aliasv xalias_ms64 (
        .MINUS(tie_low),
        .PLUS(m_aib[64])
  );

  aliasv xalias_ms67 (
        .MINUS(tie_low),
        .PLUS(m_aib[67])
  );

  aliasv xalias_ms73 (
        .MINUS(tie_low),
        .PLUS(m_aib[73])
  );

  aliasv xalias_ms74 (
        .MINUS(tie_low),
        .PLUS(m_aib[74])
  );

  aliasv xalias_ms78 (
        .MINUS(tie_low),
        .PLUS(m_aib[78])
  );

  aliasv xalias_ms79 (
        .MINUS(tie_low),
        .PLUS(m_aib[79])
  );

  aliasv xalias_ms80 (
        .MINUS(tie_low),
        .PLUS(m_aib[80])
  );

  aliasv xalias_ms81 (
        .MINUS(tie_low),
        .PLUS(m_aib[81])
  );

  aliasv xalias_ms88 (
        .MINUS(tie_low),
        .PLUS(m_aib[88])
  );

  aliasv xalias_ms89 (
        .MINUS(tie_low),
        .PLUS(m_aib[89])
  );

  aliasv xalias_ms47 (
        .MINUS(),
        .PLUS(m_aib[47])
  );

  aliasv xalias_ms46 (
        .MINUS(),
        .PLUS(m_aib[46])
  );

  aliasv xalias_ms48 (
        .MINUS(),
        .PLUS(m_aib[48])
  );


  aliasv xalias_ms50 (
        .MINUS(),
        .PLUS(m_aib[50])
  );

  aliasv xalias_ms51 (
        .MINUS(),
        .PLUS(m_aib[51])
  );

  aliasv xalias_ms52 (
        .MINUS(),
        .PLUS(m_aib[52])
  );

  aliasv xalias_ms53 (
        .MINUS(),
        .PLUS(m_aib[53])
  );

  aliasv xalias_ms54 (
        .MINUS(),
        .PLUS(m_aib[54])
  );

  aliasv xalias_ms55 (
        .MINUS(),
        .PLUS(m_aib[55])
  );

  aliasv xalias_ms60 (
        .MINUS(),
        .PLUS(m_aib[60])
  );

  aliasv xalias_ms62 (
        .MINUS(),
        .PLUS(m_aib[62])
  );


  aliasv xalias_ms66 (
        .MINUS(),
        .PLUS(m_aib[66])
  );


  aliasv xalias_ms68 (
        .MINUS(),
        .PLUS(m_aib[68])
  );


  aliasv xalias_ms69 (
        .MINUS(),
        .PLUS(m_aib[69])
  );

  aliasv xalias_ms70 (
        .MINUS(),
        .PLUS(m_aib[70])
  );

  aliasv xalias_ms71 (
        .MINUS(),
        .PLUS(m_aib[71])
  );

  aliasv xalias_ms72 (
        .MINUS(),
        .PLUS(m_aib[72])
  );

  aliasv xalias_ms75 (
        .MINUS(),
        .PLUS(m_aib[75])
  );

  aliasv xalias_ms76 (
        .MINUS(),
        .PLUS(m_aib[76])
  );

  aliasv xalias_ms77 (
        .MINUS(),
        .PLUS(m_aib[77])
  );

  aliasv xalias_ms90 (
        .MINUS(),
        .PLUS(m_aib[90])
  );

  aliasv xalias_ms91 (
        .MINUS(),
        .PLUS(m_aib[91])
  );
endmodule
