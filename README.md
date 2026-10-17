# 32:1 Analog Multiplexer Card

A 32-channel, ±15V analog multiplexer card designed for use in Automated Test Equipment (ATE), built around a 5-bit address bus, four 8-channel analog switches, and a decoder for channel selection. Designed end-to-end in EasyEDA (schematic capture through a routed 2-layer PCB), with a Verilog behavioral model of the channel-selection logic verified in Xilinx Vivado.

---

## Why This Design

Automated test setups often need to route one of many analog signals to a single measurement instrument without running a separate cable to each channel. This board takes 32 analog inputs and, based on a 5-bit digital address, switches exactly one of them through to a single buffered output — reducing 32 physical connections down to one, controllable entirely in software/logic.

---

## How It Works

- A 5-bit address (`A0`–`A4`) selects 1 of 32 channels.
- A **74HC238** decoder uses two address bits (`A3`, `A4`) to enable exactly one of four **ADG528F** analog switch ICs at a time, via active-HIGH enable lines — ensuring only one switch is ever driving the shared output.
- The remaining three address bits (`A0`–`A2`) go directly into every ADG528F's channel-select pins, so the enabled chip picks one of its 8 channels internally.
- All four ADG528F outputs are tied to a common analog bus, safe specifically because only one chip is enabled at any time.
- A **TL071** op-amp, wired as a unity-gain buffer, drives the output connector. Its input draws almost no current, so the switch's ~300Ω on-resistance causes no voltage drop between the bus and the measuring instrument.

### Address Map

| A4 | A3 | Active chip | Channels |
|---|---|---|---|
| 0 | 0 | U3 | 00H–07H |
| 0 | 1 | U4 | 08H–0FH |
| 1 | 0 | U5 | 10H–17H |
| 1 | 1 | U6 | 18H–1FH |

`A2 A1 A0` then pick the channel inside the active chip. Example: address `01011` (0BH) enables U4 and selects its 4th input, since 08H + 3 = 0BH.

---

## Key Design Decisions

**Decoder-to-switch enable mapping**
The 74HC238's four active outputs (Y0–Y3) are wired directly to each ADG528F's active-HIGH EN pin, so exactly one of the four 8-channel switches is live at any given address — avoiding any possibility of two switches driving the output bus simultaneously.

**Decoupling throughout**
Every IC's power pins are decoupled with dedicated capacitors branching off the supply rail rather than sitting inline, to avoid interrupting the ±15V/+5V supply paths while still filtering switching noise close to each chip.

**Output buffering**
Rather than sending the raw multiplexed signal straight to the output connector, a TL071 unity-gain buffer isolates the ADG528F's ~300Ω switch resistance from the measuring instrument, preserving signal accuracy.

---

## Technical Specifications

| Item | Detail |
|---|---|
| Channels | 32 (00H–1FH) |
| Analog signal range | ±15V supplies |
| Address bus | 5-bit (A0–A4) |
| Key ICs | 4× ADG528F (analog switch), 74HC238 (decoder), TL071 (buffer) |
| PCB | 2-layer, routed in EasyEDA |
| Design tool | EasyEDA (schematic capture + PCB layout) |
| Logic model | Verilog, simulated in Xilinx Vivado |
| Model verification | Self-checking testbench, 32/32 channels selected correctly |

---

## Verilog Behavioral Model

A Verilog model of the selection logic lives in `verilog_model/`. It mirrors the board's structure: a top module instantiating one decoder, four 8:1 muxes and an output buffer.

```
mux32x1_top
├── decoder    (3-to-8, active-HIGH outputs, models the 74HC238)
├── mux_8x1 ×4 (models one ADG528F: EN active-high, RS active-low reset, A0–A2 select)
└── buffer     (unity-gain output stage)
```

**What the testbench checks**

For each of the 32 addresses, the testbench drives only the addressed channel high (all other channels low) and checks that the output is high. A wrong chip or a wrong channel index would read low and report an error. It then checks the all-zero case and disables the decoder to confirm the shared bus goes high-impedance (no chip drives it).

**Result:** 32 of 32 channels selected correctly, 0 errors.

**What the model does not cover**

Each channel is a single logic bit, so the model verifies the addressing and enable logic only. It does not model the analog behavior: ±15V signal levels, switch on-resistance, bandwidth or timing. Those are not verified in simulation.

**How to run**

- *Vivado:* add the five files under `verilog_model/`, set `tb_32x1mux` as the simulation top, and run Behavioral Simulation. The Tcl console prints one `PASS` line per channel.
- *Icarus Verilog:*
```bash
  cd verilog_model
  iverilog -g2012 -o sim buffer.v decoder.v mux_8x1.v mux32x1_top.v tb_32x1mux.v
  vvp sim
```

---

## Project Files

| File | Description |
|---|---|
| `Schematic.pdf` | Full circuit schematic (EasyEDA) |
| `pcb_2d_layout.png` | Routed 2-layer PCB layout (top + bottom copper) |
| `pcb_3d_render.png` | 3D rendered view of the assembled board |
| `pcb_2d_render.png` | 2D rendered view of the assembled board |
| `gerber_files.zip` | Fabrication-ready Gerber files |
| `interactiveBOM.html` | Interactive Bill of Materials with clickable 3D board view |
| `verilog_model/mux32x1_top.v` | Top-level 32:1 model |
| `verilog_model/decoder.v` | 3-to-8 decoder model |
| `verilog_model/mux_8x1.v` | 8:1 analog switch model |
| `verilog_model/buffer.v` | Output buffer model |
| `verilog_model/tb_32x1mux.v` | Self-checking testbench |
| `verilog_model/rtl_schematic.pdf` | Vivado elaborated RTL schematic of the model |

---

## Author

**Chhavi Verma**
ECE | Digital Design & RTL
