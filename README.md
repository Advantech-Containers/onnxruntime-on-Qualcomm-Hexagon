# ONNX Runtime on Qualcomm Hexagon

**Version:** 1.0

**Release Date:** May 2026

**Copyright:** © 2026 Advantech Corporation. All rights reserved.


This document describes how to validate the Qualcomm NPU-enabled ONNX Runtime container on the Qualcomm Hexagon platform.

## 1. Hardware Specifications
> [!NOTE]
> This container image is compatible with Advantech AOM-2721, Advantech AIR-055 and Advantech AFE-A503.

| Component       | Specification      |
|-----------------|--------------------|
| Target Hardware | [Advantech AOM-2721](https://www.advantech.com/en-us/products/risc_evaluation_kit/aom-dk2721/mod_0e561ece-295c-4039-a545-68f8ded469a8) |
| SoC             | Qualcomm® QCS6490   |
| GPU             | Qualcomm® Adreno™ 643        |
| DSP             | Qualcomm® Hexagon™ 770 (12 TOPs) |
| Memory          | 8GB LPDDR5         |


| Component       | Specification      |
|-----------------|--------------------|
| Target Hardware | [Advantech AIR-055](https://www.advantech.com/en-us/products/932c8818-07cc-4917-89e9-7a678ddc029c/air-055/mod_4e23ea2a-d196-4884-8c62-c31780fbafb0) |
| SoC             | Qualcomm® Dragonwing™ IQ-9075   |
| GPU             | Qualcomm® Adreno™ 663        |
| DSP             | Qualcomm® Hexagon™ (100 TOPs) |
| Memory          | 36GB LPDDR5         |

| Component       | Specification      |
|-----------------|--------------------|
| Target Hardware | [Advantech AFE-A503](https://www.advantech.com/zh-tw/products/8d5aadd0-1ef5-4704-a9a1-504718fb3b41/afe-a503/mod_12fdad30-7018-42b3-8d55-4b463f90166b) |
| SoC             | Qualcomm® Dragonwing™ IQ-9075M   |
| GPU             | Qualcomm® Adreno™ 663        |
| DSP             | Qualcomm® Hexagon™ (100 TOPs) |
| Memory          | 32GB LPDDR5         |

## 2. Software Components

| Component             | Version | Description                                                        |
| --------------------- | ------- | ------------------------------------------------------------------ |
| Ubuntu                | 22.04   | Guest OS                                                           |
| Python                | 3.10    | Runtime environment                                                |
| ONNX Runtime (QNN EP) | 1.24.1  | Custom build with QNN Execution Provider (Built with QAIRT 2.43.0) |
| QAIRT (QNN SDK)       | 2.43.0  | Qualcomm AI Runtime backend library                                |
| LiteRT                | 2.1.4   | Provides QNN TFLite Delegate support for GPU/NPU acceleration      |
| Gstreamer             | 1.20.3  | Multimedia framework for building flexible audio/video pipelines   |

**Note**: The custom build of `onnxruntime-qnn` currently only works within this container environment.

## 3. Run Container
Clone the project:
- On the PC
```
git clone https://github.com/Advantech-EdgeSync-Containers/onnxruntime-on-Qualcomm-Hexagon.git
scp -r ./onnxruntime-on-Qualcomm-Hexagon-main\ <username>@<development-board-ip>:/home/<username>/
```
- On device (AOM-2721, AIR-055, AFE-A503, ...)
```
chmod +x -R onnxruntime-on-Qualcomm-Hexagon-main
cd onnxruntime-on-Qualcomm-Hexagon-main
```

Start the container:
```
./run-container.sh
```
This script launches the container and opens an interactive shell.

## 4. Exit container
Inside the container, type:
```
exit
```

Expected output:
```
Exited container. Cleaning up...
[+] Running 2/2
 ✔ Container onnxruntime-on-qualcomm-hexagon       Removed                                                                                 10.4s 
 ✔ Network onnxruntime-on-qualcomm-hexagon_default  Removed  
```

## 5. Test ONNX Runtime with NPU capability
1. Run the wise-bench script:
```
cd /benchmark
./wise-bench.sh
```
Wise-Bench Result 
- AOM-2721 Result
```
+--- FINAL SUMMARY TABLE --------------------------------+
|                                                  |
+--------------------------------------------------+
+--------------------------------------------------+
| Summary Results                                |
+--------------------------------------------------+
| QNN GPU Backend           | 2.43.0 | Supported |
| QNN NPU Backend           | 2.43.0 | Supported |
| SNPE GPU Runtime          | 2.43.0 | Supported |
| SNPE NPU Runtime          | 2.43.0 | Supported |
| LiteRT QNN Delegate       | 2.1.5  | Supported |
| GStreamer                 | 1.20.3 | Supported |
| ONNX Runtime QNN EP       | 1.24.1 | Supported |
+--------------------------------------------------+
| Overall Score             | 100% (7/7) |
| Progress                  | ████████████████████ |

+--- DIAGNOSTICS COMPLETE -------------------------------+
|                                                  |
+--------------------------------------------------+

+--- All diagnostics completed --------------------------+
|                                                  |
+--------------------------------------------------+
>>> Diagnostic Completed at: 2026-07-08 07:58:08
```
- AIR-055 Result
```
+--- FINAL SUMMARY TABLE --------------------------------+
|                                                  |
+--------------------------------------------------+
+--------------------------------------------------+
| Summary Results                                |
+--------------------------------------------------+
| QNN GPU Backend           | 2.43.0 | Not Supported |
| QNN NPU Backend           | 2.43.0 | Not Supported |
| SNPE GPU Runtime          | 2.43.0 | Not Supported |
| SNPE NPU Runtime          | 2.43.0 | Not Supported |
| LiteRT QNN Delegate       | 2.1.5  | Supported |
| GStreamer                 | 1.20.3 | Supported |
| ONNX Runtime QNN EP       | 1.24.1 | Supported |
+--------------------------------------------------+
| Overall Score             | 42% (3/7) |
| Progress                  | ████████░░░░░░░░░░░░ |

+--- DIAGNOSTICS COMPLETE -------------------------------+
|                                                  |
+--------------------------------------------------+

+--- All diagnostics completed --------------------------+
|                                                  |
+--------------------------------------------------+
>>> Diagnostic Completed at: 2026-07-08 07:45:52
``` 
2. Run the benchmark script:
```
cd /benchmark
python benchmark.py
```

Benchmark Result (100 Iterations)

Model: [EfficientNet-B0](https://aihub.qualcomm.com/models/efficientnet_b0)

Quantiaztion: w8a16

**Model is download from Qualcomm AI-Hub**
- AOM-2721 Result
```
============================================================
PERFORMANCE COMPARISON
============================================================
[CPU Execution Provider] Running 100 iterations...
[QNN Execution Provider] Running 100 iterations...
------------------------- ----------
Backend                          FPS
------------------------- ----------
CPU Execution Provider          7.42
QNN Execution Provider        174.21

[Result] QNN Execution Provider is 23.47x faster than CPU (Average)

```

- AIR-055 Result

```
============================================================
PERFORMANCE COMPARISON
============================================================
[CPU Execution Provider] Running 100 iterations...
[QNN Execution Provider] Running 100 iterations...
------------------------- ----------
Backend                          FPS
------------------------- ----------
CPU Execution Provider         25.98
QNN Execution Provider        325.80

[Result] QNN Execution Provider is 12.54x faster than CPU (Average)
```

The result confirms that inference is successfully offloaded to the Hexagon NPU through the QNN Execution Provider, achieving approximately 174.21fps - 325.80 fps acceleration compared to CPU execution on AOM-2721 and AIR-055, respectively.

## 6. Development Workflow

The container uses a bind mount configuration:
```
volumes:
  - ./:/workspace/
```
The host project directory (e.g., onnxruntime-on-Qualcomm-Hexagon-main) is directly synchronized with /workspace inside the container.

You can create or modify Python files directly in the host project folder, and they will be immediately available inside the container without rebuilding the image.

### Example
Create a new Python file on the host:
```
touch test.py
```

Edit `test.py` with the following content:

```
import onnxruntime as ort
print(ort.get_available_providers())
```

Switch to `/workspace` in the conatiner:
```
cd /workspace
```

Run it inside the container:
```
python test.py
```

Expected output:
```
['QNNExecutionProvider', 'CPUExecutionProvider']
```

If `QNNExecutionProvider` appears in the output, it confirms that the QNN Execution Provider is successfully enabled and the container can access the Hexagon NPU.


This workflow enables rapid development and testing while keeping the runtime environment isolated within the container.


