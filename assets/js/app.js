// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css"

import React from "react"
import { render } from "react-dom"
import { BreakpointsProvider } from "cozy-ui/transpiled/react/hooks/useBreakpoints"
import MuiCozyTheme from "cozy-ui/transpiled/react/MuiCozyTheme"
import Warning from "./Warning.jsx"
;(function (w, d) {
  const wrapReact = (element, app) => {
    render(
      <BreakpointsProvider>
        <MuiCozyTheme>{app}</MuiCozyTheme>
      </BreakpointsProvider>,
      element
    )
  }

  const warning = d.getElementById("react-warning")
  if (warning) {
    const app = (
      <Warning
        button={warning.innerText}
        title={warning.dataset.title}
        content={warning.dataset.content}
        confirm={warning.dataset.confirm}
        cancel={warning.dataset.cancel}
      />
    )
    wrapReact(warning.parentElement, app)
  }
})(window, document)
