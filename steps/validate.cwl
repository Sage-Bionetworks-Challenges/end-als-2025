#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
label: Validate file submissions

requirements:
- class: InlineJavascriptRequirement
- class: InitialWorkDirRequirement
  listing:
  - entryname: validate.py
    entry: |
    #!/usr/bin/env python
    import argparse
    import json
    from pathlib import Path

    parser = argparse.ArgumentParser()
    parser.add_argument("-r", "--results", required=True, help="validation results")
    parser.add_argument("-e", "--entity_type", required=True, help="synapse entity type downloaded")
    parser.add_argument("-s", "--submission_file", help="Submission File")

    args = parser.parse_args()

    submission_status = "INVALID"
    invalid_reasons = []

    if args.submission_file is None:
        prediction_file_status = "INVALID"
        invalid_reasons.append(f"Expected FileEntity type but found {args.entity_type}")
    else:
        acceptable_file_exts = {".doc", ".docx", ".pdf", ".rtf", ".txt"}
        extension = Path(args.submission_file).suffix.lower()
        
        if extension in acceptable_file_exts:
            submission_status = "VALID"
        else:
            invalid_reasons.append(
                f"Invalid file extension: {extension}"
                f"Accepted extensions are {', '.join(sorted(list(acceptable_file_exts)))}."
            )
        
    result = {"submission_errors": "\n".join(invalid_reasons),
              "submission_status": submission_status}
    with open(args.results, 'w') as o:
        o.write(json.dumps(result))

inputs:
  - id: input_file
    type: File?
  - id: entity_type
    type: string

outputs:
  - id: results
    type: File
    outputBinding:
      glob: results.json
  - id: status
    type: string
    outputBinding:
      glob: results.json
      outputEval: $(JSON.parse(self[0].contents)['submission_status'])
      loadContents: true
  - id: invalid_reasons
    type: string
    outputBinding:
      glob: results.json
      outputEval: $(JSON.parse(self[0].contents)['submission_errors'])
      loadContents: true

baseCommand: python
arguments:
  - valueFrom: validate.py
  - prefix: -s
    valueFrom: $(inputs.input_file)
  - prefix: -e
    valueFrom: $(inputs.entity_type)
  - prefix: -r
    valueFrom: results.json

hints:
  DockerRequirement:
    dockerPull: python:3.12-slim-buster

s:author:
- class: s:Person
  s:identifier: https://orcid.org/0000-0002-5622-7998
  s:email: verena.chung@sagebase.org
  s:name: Verena Chung

s:codeRepository: https://github.com/Sage-Bionetworks-Challenges/end-als-2025

$namespaces:
  s: https://schema.org/