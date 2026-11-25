import CoreGraphics
import Foundation
// usage: winid <owner substring> <title substring>  -> prints window id of best match
let args = CommandLine.arguments
let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as! [[String: Any]]
for w in list {
  let owner = w[kCGWindowOwnerName as String] as? String ?? ""
  let name = w[kCGWindowName as String] as? String ?? ""
  if args.count < 2 { print(w[kCGWindowNumber as String]!, owner, "|", name); continue }
  if owner.contains(args[1]) && name.contains(args[2]) { print(w[kCGWindowNumber as String]!); break }
}
