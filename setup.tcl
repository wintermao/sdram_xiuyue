#system
	set_global_assignment -name FAMILY "Cyclone II"
	set_global_assignment -name DEVICE EP2C8T144C6
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION "6.0 SP1"
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "16:10:43  MARCH 26, 2007"
	set_global_assignment -name LAST_QUARTUS_VERSION "6.0 SP1"
	set_global_assignment -name DEVICE_FILTER_PACKAGE TQFP
	set_global_assignment -name DEVICE_FILTER_PIN_COUNT 144
	set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 6
	set_global_assignment -name BDF_FILE sdram_test.bdf
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
	set_global_assignment -name RESERVE_ASDO_AFTER_CONFIGURATION "AS INPUT TRI-STATED"
	set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_NO_OUTPUT_GND "AS INPUT TRI-STATED"
	set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
	set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
	set_global_assignment -name PHYSICAL_SYNTHESIS_ASYNCHRONOUS_SIGNAL_PIPELINING ON
	set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
#clock	
	set_location_assignment PIN_17 -to clock
	set_location_assignment PIN_53 -to sdram_clk
	set_location_assignment PIN_90 -to rst_n
#i2c	
	set_location_assignment PIN_129 -to SDA_MASTER
	set_location_assignment PIN_112 -to SCL_MASTER
#uart	
	set_location_assignment PIN_69 -to RXD_1
	set_location_assignment PIN_70 -to TXD_1
	set_location_assignment PIN_21 -to RXD_2
	set_location_assignment PIN_72 -to TXD_2
	set_location_assignment PIN_91 -to RXD_3
	set_location_assignment PIN_71 -to TXD_3
#sdram	
	set_location_assignment PIN_122 -to sdram_bank[0]
	set_location_assignment PIN_121 -to sdram_bank[1]
	set_location_assignment PIN_134 -to sdram_dqm[0]
	set_location_assignment PIN_52 -to sdram_dqm[1]
	set_location_assignment PIN_126 -to sdram_cas_n
	set_location_assignment PIN_125 -to sdram_ras_n
	set_location_assignment PIN_133 -to sdram_we_n
	set_location_assignment PIN_118 -to sdram_addr[0]
	set_location_assignment PIN_115 -to sdram_addr[1]
	set_location_assignment PIN_114 -to sdram_addr[2]
	set_location_assignment PIN_113 -to sdram_addr[3]
	set_location_assignment PIN_65 -to sdram_addr[4]
	set_location_assignment PIN_64 -to sdram_addr[5]
	set_location_assignment PIN_60 -to sdram_addr[6]
	set_location_assignment PIN_59 -to sdram_addr[7]
	set_location_assignment PIN_58 -to sdram_addr[8]
	set_location_assignment PIN_57 -to sdram_addr[9]
	set_location_assignment PIN_119 -to sdram_addr[10]
	set_location_assignment PIN_55 -to sdram_addr[11]
	set_location_assignment PIN_144 -to sdram_dq[0]
	set_location_assignment PIN_143 -to sdram_dq[1]
	set_location_assignment PIN_142 -to sdram_dq[2]
	set_location_assignment PIN_141 -to sdram_dq[3]
	set_location_assignment PIN_139 -to sdram_dq[4]
	set_location_assignment PIN_137 -to sdram_dq[5]
	set_location_assignment PIN_136 -to sdram_dq[6]
	set_location_assignment PIN_135 -to sdram_dq[7]
	set_location_assignment PIN_48 -to sdram_dq[8]
	set_location_assignment PIN_47 -to sdram_dq[9]
	set_location_assignment PIN_45 -to sdram_dq[10]
	set_location_assignment PIN_44 -to sdram_dq[11]
	set_location_assignment PIN_43 -to sdram_dq[12]
	set_location_assignment PIN_42 -to sdram_dq[13]
	set_location_assignment PIN_41 -to sdram_dq[14]
	set_location_assignment PIN_40 -to sdram_dq[15]
#led	
	set_location_assignment PIN_104 -to LED[0]
	set_location_assignment PIN_103 -to LED[1]
	set_location_assignment PIN_101 -to LED[2]
	set_location_assignment PIN_100 -to LED[3]
	set_location_assignment PIN_51 -to LED[4]

#key	
	set_location_assignment PIN_89 -to KEY[0]
	set_location_assignment PIN_88 -to KEY[1]
#	set_location_assignment PIN_63 -to KEY[2]




