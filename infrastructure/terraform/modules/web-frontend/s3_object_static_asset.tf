# resource "aws_s3_object" "static_asset" {
#   for_each = {
#     for f in fileset("${path.root}/../../static_content/${var.pipeline_component_static}", "**") :
#     f => {
#       path          = replace(f, "/\\.html$/", "")
#       content_type  = length(split(".", f)) > 1 ? lookup(local.file_types, split(".", f)[tonumber(length(split(".", f)) - 1)], local.default_file_type) : length(regexall("^page", f)) > 0 ? lookup(local.file_types, "html") : length(regexall("^metadata", f)) > 0 ? lookup(local.file_types, "json") : local.default_file_type
#       cache_control = length(regexall("^(page|metadata)", f)) > 0 ? "max-age=10" : "max-age=604800"
#     }
#   }
#   bucket        = aws_s3_bucket.static_assets.bucket
#   key           = each.value.path
#   source        = "${path.root}/../../static_content/${var.pipeline_component_static}/${each.key}"
#   etag          = filemd5("${path.root}/../../static_content/${var.pipeline_component_static}/${each.key}")
#   cache_control = each.value.cache_control
#   content_type  = each.value.content_type
# }
