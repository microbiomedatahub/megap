#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: MeGAPTaxa.sh
hints:
  DockerRequirement:
    dockerPull: ghcr.io/satoshi0409/megap/megap-for-cwl:latest
inputs:
  input_data_path:
    type: Directory
    inputBinding:
      position: 1
  input_ref_path:
    type: Directory
    inputBinding:
      position: 2
outputs:
  out:
    type: Directory
    outputBinding:
      glob: $(runtime.outdir)


