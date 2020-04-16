## Constraints (Experimental!)
4/16/2020

####PAR Levels
- PAR1: Frontend (Single IO Rx and Tx, level shifters)
- PAR2: 40 IO AIB channel with DLL, DCC and clock routing
- PAR3: AIB channel including adapter (FIFO, sideband register, MAC/PHY interface)

The constraints have been used to produce a Master side AIB design, but note that some signal names in these files predate the rev2 standardization of the code to match the AIB 1.2 spec.

The AIB Usage Note's Table 2 provides some signal translations.

Conversion of the constraints to match the rev2 code will be welcomed.
