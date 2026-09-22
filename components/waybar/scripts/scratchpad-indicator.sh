#!/usr/bin/env bash
set -euo pipefail

clients_json="$(hyprctl clients -j)"
monitors_json="$(hyprctl monitors -j)"

jq -nc \
  --argjson clients "$clients_json" \
  --argjson monitors "$monitors_json" '
  def esc:
    gsub("&"; "&amp;")
    | gsub("<"; "&lt;")
    | gsub(">"; "&gt;")
    | gsub("\""; "&quot;");

  def bracket($name; $visible):
    if $visible then
      "<span underline=\"single\" weight=\"bold\">" + ($name | esc) + "</span>"
    else
      "" + ($name | esc) + ""
    end;

  # windowが存在するspecial workspace
  ($clients
    | map(.workspace.name)
    | map(select(startswith("special:")))
    | map(sub("^special:"; ""))
    | unique
  ) as $occupied |

  # 現在monitor上に表示されているspecial workspace
  ($monitors
    | map(.specialWorkspace.name // empty)
    | map(select(startswith("special:")))
    | map(sub("^special:"; ""))
    | unique
  ) as $visible |

  # 表示対象 = occupied ∪ visible
  (($occupied + $visible) | unique) as $shown |

  if ($shown | length) == 0 then
    {
      text: "",
      tooltip: "No special workspace windows",
      class: ["scratchpad", "empty"]
    }
  else
    {
      text: (
        $shown
        | map(. as $name | bracket($name; $visible | index($name) != null))
        | join(" ")
      ),
      tooltip: (
        $shown
        | map(
            if ($visible | index(.) != null) and ($occupied | index(.) != null) then
              "[" + . + "] visible, occupied"
            elif ($visible | index(.) != null) then
              "[" + . + "] visible, empty"
            else
              "[" + . + "] occupied"
            end
          )
        | join("\n")
      ),
      class: [
        "scratchpad",
        if ($visible | length) > 0 then "active" else "occupied" end
      ]
    }
  end
'