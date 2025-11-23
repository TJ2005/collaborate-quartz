import { FilePath, FullSlug } from "../../util/path"
import { QuartzEmitterPlugin } from "../types"
import { write } from "./helpers"

export const Htaccess: QuartzEmitterPlugin = () => ({
  name: "Htaccess",
  async emit(ctx) {
    const htaccessContent = `RewriteEngine On
 
ErrorDocument 404 /404.html
 
# Rewrite rule for .html extension removal (with directory check)
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_URI}.html -f
RewriteRule ^(.*)$ $1.html [L]
 
# Handle directory requests explicitly
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^(.*)/$ $1/index.html [L]
`

    const path = await write({
      ctx,
      content: htaccessContent,
      slug: ".htaccess" as FullSlug,
      ext: "",
    })
    
    return [path]
  },
  async *partialEmit() {},
})
