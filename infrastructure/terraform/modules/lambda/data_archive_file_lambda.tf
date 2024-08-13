data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/${var.function_code_base_path}/${var.function_code_dir}"
  output_path = "${path.module}/archives/${local.csi}.zip"
  excludes = [
    # Python Exclusions
    "**/test",
    "**/__pycache__",

    # NodeJS Exclusions
    "**/__tests__",
    "**/node_modules",
    "**/package.json",
    "**/package-lock.json",
  ]
}
