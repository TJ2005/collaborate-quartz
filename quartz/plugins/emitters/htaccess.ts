import { FilePath, FullSlug } from "../../util/path"
import { QuartzEmitterPlugin } from "../types"

export const Htaccess: QuartzEmitterPlugin = () => {
  return {
    name: "Htaccess",
    emit: async (_ctx, _content, _resources) => {
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

      return [
        {
          slug: ".htaccess" as FullSlug,
          ext: "",
          content: htaccessContent,
        },
      ]
    },
    getQuartzComponents: () => [],
  }
}
