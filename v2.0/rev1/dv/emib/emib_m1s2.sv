module emib_m1s2 (
	inout [101:0] s_ch0_aib,
	inout [101:0] s_ch1_aib,
	inout [101:0] s_ch2_aib,
	inout [101:0] s_ch3_aib,
	inout [101:0] s_ch4_aib,
	inout [101:0] s_ch5_aib,
	inout [101:0] s_ch6_aib,
	inout [101:0] s_ch7_aib,
	inout [101:0] s_ch8_aib,
	inout [101:0] s_ch9_aib,
        inout [101:0] s_ch10_aib,
        inout [101:0] s_ch11_aib,
        inout [101:0] s_ch12_aib,
        inout [101:0] s_ch13_aib,
        inout [101:0] s_ch14_aib,
        inout [101:0] s_ch15_aib,
        inout [101:0] s_ch16_aib,
        inout [101:0] s_ch17_aib,
        inout [101:0] s_ch18_aib,
        inout [101:0] s_ch19_aib,
        inout [101:0] s_ch20_aib,
        inout [101:0] s_ch21_aib,
        inout [101:0] s_ch22_aib,
        inout [101:0] s_ch23_aib,
	inout [95:0] m_ch0_aib,
	inout [95:0] m_ch1_aib,
	inout [95:0] m_ch2_aib,
	inout [95:0] m_ch3_aib,
	inout [95:0] m_ch4_aib,
	inout [95:0] m_ch5_aib,
	inout [95:0] m_ch6_aib,
	inout [95:0] m_ch7_aib,
	inout [95:0] m_ch8_aib,
	inout [95:0] m_ch9_aib,
        inout [95:0] m_ch10_aib,
        inout [95:0] m_ch11_aib,
        inout [95:0] m_ch12_aib,
        inout [95:0] m_ch13_aib,
        inout [95:0] m_ch14_aib,
        inout [95:0] m_ch15_aib,
        inout [95:0] m_ch16_aib,
        inout [95:0] m_ch17_aib,
        inout [95:0] m_ch18_aib,
        inout [95:0] m_ch19_aib,
        inout [95:0] m_ch20_aib,
        inout [95:0] m_ch21_aib,
        inout [95:0] m_ch22_aib,
        inout [95:0] m_ch23_aib


	);

 emib_ch_m1s2  ch0 (
        .s_aib(s_ch0_aib),
        .m_aib(m_ch0_aib)
        );

 emib_ch_m1s2  ch1 (
        .s_aib(s_ch1_aib),
        .m_aib(m_ch1_aib)
        );

 emib_ch_m1s2  ch2 (
        .s_aib(s_ch2_aib),
        .m_aib(m_ch2_aib)
        );

 emib_ch_m1s2  ch3 (
        .s_aib(s_ch3_aib),
        .m_aib(m_ch3_aib)
        );

 emib_ch_m1s2  ch4 (
        .s_aib(s_ch4_aib),
        .m_aib(m_ch4_aib)
        );

 emib_ch_m1s2  ch5 (
        .s_aib(s_ch5_aib),
        .m_aib(m_ch5_aib)
        );

 emib_ch_m1s2  ch6 (
        .s_aib(s_ch6_aib),
        .m_aib(m_ch6_aib)
        );

 emib_ch_m1s2  ch7 (
        .s_aib(s_ch7_aib),
        .m_aib(m_ch7_aib)
        );

 emib_ch_m1s2  ch8 (
        .s_aib(s_ch8_aib),
        .m_aib(m_ch8_aib)
        );

 emib_ch_m1s2  ch9 (
        .s_aib(s_ch9_aib),
        .m_aib(m_ch9_aib)
        );

 emib_ch_m1s2  ch10 (
        .s_aib(s_ch10_aib),
        .m_aib(m_ch10_aib)
        );

 emib_ch_m1s2  ch11 (
        .s_aib(s_ch11_aib),
        .m_aib(m_ch11_aib)
        );

 emib_ch_m1s2  ch12 (
        .s_aib(s_ch12_aib),
        .m_aib(m_ch12_aib)
        );

 emib_ch_m1s2  ch13 (
        .s_aib(s_ch13_aib),
        .m_aib(m_ch13_aib)
        );

 emib_ch_m1s2  ch14 (
        .s_aib(s_ch14_aib),
        .m_aib(m_ch14_aib)
        );

 emib_ch_m1s2  ch15 (
        .s_aib(s_ch15_aib),
        .m_aib(m_ch15_aib)
        );

 emib_ch_m1s2  ch16 (
        .s_aib(s_ch16_aib),
        .m_aib(m_ch16_aib)
        );

 emib_ch_m1s2  ch17 (
        .s_aib(s_ch17_aib),
        .m_aib(m_ch17_aib)
        );

 emib_ch_m1s2  ch18 (
        .s_aib(s_ch18_aib),
        .m_aib(m_ch18_aib)
        );

 emib_ch_m1s2  ch19 (
        .s_aib(s_ch19_aib),
        .m_aib(m_ch19_aib)
        );

 emib_ch_m1s2  ch20 (
        .s_aib(s_ch20_aib),
        .m_aib(m_ch20_aib)
        );

 emib_ch_m1s2  ch21 (
        .s_aib(s_ch21_aib),
        .m_aib(m_ch21_aib)
        );

 emib_ch_m1s2  ch22 (
        .s_aib(s_ch22_aib),
        .m_aib(m_ch22_aib)
        );

 emib_ch_m1s2  ch23 (
        .s_aib(s_ch23_aib),
        .m_aib(m_ch23_aib)
        );

endmodule
