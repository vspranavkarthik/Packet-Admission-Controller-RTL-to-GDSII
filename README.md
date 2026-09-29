# Packet Admission Controller — Source Package

## Contents
- `src/packet_admission_ctrl.v` — clean synthesizable RTL reference.
- `tb/tb_packet_admission_ctrl.v` — functional simulation testbench.
- `config/config.json` — LibreLane configuration used for the project flow.
- `docs/README.md` — project notes.

## Important provenance note
The uploaded GDS ZIP contains the completed LibreLane run and generated implementation artifacts, but it does **not** contain the original `src/` or `tb/` directories. Therefore the RTL and testbench in this package are a clean reconstructed reference based on the documented Packet Admission Controller interface and FSM behavior. They should not be described as the byte-for-byte original source.

The authoritative physical implementation artifacts remain in the original GDSReady ZIP.

## Functional behavior
IDLE --SOP--> RECEIVE
RECEIVE --EOP & no error--> ACCEPT
RECEIVE --error--> DROP
ACCEPT --> IDLE
DROP --> IDLE
