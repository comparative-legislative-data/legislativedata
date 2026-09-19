// The Insights page's charts. Strand 3: docs/STRAND-3-PLAN.md, and for the
// outcomes chart, docs/STRAND-3-THOUGHT-2.md and
// docs/STRAND-3-THOUGHT-2-PAGE-BUILD.md. Drawn from the whole-page mock-up of
// 19 September, which the owner confirmed; nothing it did is left out.
//
// Every figure comes from the copy, handed over in the page; nothing is worked
// out here. A figure opens the bills behind it on the Data page, whose address
// names the figure's line in the copy.
(function () {
  "use strict";
  var $ = function (id) { return document.getElementById(id); };
  var root = document.documentElement;
  var css = function (n) { return getComputedStyle(root).getPropertyValue(n).trim(); };
  var esc = function (s) {
    return String(s == null ? "" : s).replace(/[&<>"]/g, function (c) {
      return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c];
    });
  };

  // Each outcome's colour, from the stylesheet's chart palette, which passed the
  // palette check (docs/STRAND-3-THOUGHT-2-PAGE-BUILD.md). An outcome without
  // one would need the check run again for it; until then it is drawn faint.
  var COLOUR = {
    "Passed": "--o-passed", "Rejected at Stage 1": "--o-rej1", "Rejected at Stage 3": "--o-rej3",
    "Withdrawn": "--o-withdrawn", "Fell at dissolution": "--o-dissolution",
    "Fell: financial resolution not agreed": "--o-finres", "In progress": "--o-progress",
    "Not passed": "--o-notpassed"
  };
  var colour = function (o) { return css(COLOUR[o] || "--text-faint"); };

  // White or near-black ink for a count on a coloured part, whichever reads.
  function inkOn(hex) {
    var v = hex.replace("#", "");
    var c = [0, 2, 4].map(function (i) { return parseInt(v.slice(i, i + 2), 16) / 255; })
      .map(function (x) { return x <= 0.03928 ? x / 12.92 : Math.pow((x + 0.055) / 1.055, 2.4); });
    var L = 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2];
    return L > 0.22 ? "#1a1816" : "#fdfcfb";
  }

  // ---- The outcomes chart (thought 2) ----------------------------------------
  var D = JSON.parse($("oc-data").textContent);
  var FORTH = { grouped: "Counted as a government bill", onown: "Shown as a Hybrid Bill" };
  // rows: [outcomes_shown, grouped|onown, session, bill_type, outcome,
  //        bills_of_this_type, bills, percent, of_which_became_acts]
  var IX = {};
  D.rows.forEach(function (r) {
    IX[[r[0], r[1], r[2], r[3], r[4]].join("|")] = { bt: r[5], n: r[6], p: r[7], acts: r[8] };
  });
  var line = function (view, sw, s, t, o) { return IX[[view, sw, s, t, o].join("|")]; };
  var sessName = function (s) { return s === "All sessions" ? s : "Session " + s; };

  function figureAddress(view, sw, s, t, o, acts) {
    var q = [["figure", D.figure], ["outcomes_shown", view], ["forth_crossing_bill", FORTH[sw]],
             ["session", s], ["bill_type", t]];
    if (o) q.push(["outcome", o]);
    if (acts) q.push(["became_acts", "Yes"]);
    return "/data?" + q.map(function (p) { return p[0] + "=" + encodeURIComponent(p[1]); }).join("&");
  }

  var chart;
  function choices() { return { view: $("oc-outcomes").value, sw: $("oc-forth").value }; }

  function slotsFor(sw) {
    var types = D.types[sw], s0 = [];
    D.sessions.forEach(function (x) {
      types.forEach(function (t) { s0.push({ s: x[0], t: t }); });
      s0.push(null);
    });
    return [s0, types.map(function (t) { return { s: "All sessions", t: t }; })];
  }

  function build() {
    var c = choices(), view = c.view, sw = c.sw;
    var outcomes = D.outcomes[view], slots = slotsFor(sw);
    var bills = function (sl) { return line(view, sw, sl.s, sl.t, outcomes[0]).bt; };
    var text = css("--text"), muted = css("--text-muted"), strong = css("--text-strong"),
        border = css("--border"), surface = css("--surface"), raised = css("--raised");
    var maxOf = function (sl) {
      return Math.max.apply(null, [1].concat(sl.filter(Boolean).map(bills)));
    };
    var labelMin = [maxOf(slots[0]) * 0.045, maxOf(slots[1]) * 0.045];

    var series = [];
    [0, 1].forEach(function (panel) {
      outcomes.forEach(function (o) {
        var fill = colour(o);
        series.push({
          name: o, type: "bar", stack: "bills" + panel,
          xAxisIndex: panel * 2, yAxisIndex: panel, barWidth: panel ? "62%" : "78%",
          cursor: "pointer",
          itemStyle: { color: fill, borderColor: panel ? raised : surface, borderWidth: 1 },
          label: { show: true, position: "inside", fontSize: 10, fontFamily: "IBM Plex Sans", color: inkOn(fill),
            formatter: function (p) { return p.value > 0 && p.value >= labelMin[panel] ? p.value : ""; } },
          data: slots[panel].map(function (sl) { return sl ? line(view, sw, sl.s, sl.t, o).n : 0; })
        });
      });
      // The number of bills above each bar, "–" where none were introduced.
      series.push({
        name: "total" + panel, type: "bar", stack: "bills" + panel, xAxisIndex: panel * 2, yAxisIndex: panel,
        silent: true, itemStyle: { color: "transparent" }, tooltip: { show: false },
        label: { show: true, position: "top", distance: 3, color: muted, fontSize: 10, fontFamily: "IBM Plex Sans",
          formatter: function (p) {
            var sl = slots[panel][p.dataIndex];
            if (!sl) return "";
            var b = bills(sl);
            return b === 0 ? "–" : b;
          } },
        data: slots[panel].map(function () { return 0.0001; })
      });
    });

    var typeAxis = function (panel, gridIndex) {
      return { type: "category", gridIndex: gridIndex, position: "bottom",
        data: slots[panel].map(function (sl) { return sl ? D.typeNames[sl.t][0] : ""; }),
        axisTick: { show: false }, axisLine: { lineStyle: { color: border } },
        axisLabel: { color: muted, fontSize: 10, interval: 0, rotate: 90 } };
    };
    var groupAxis = function (labels, gridIndex) {
      return { type: "category", gridIndex: gridIndex, position: "bottom", offset: 50, data: labels,
        axisTick: { show: false }, axisLine: { show: false },
        axisLabel: { color: strong, fontSize: 12, fontWeight: 600, lineHeight: 16, interval: 0 } };
    };
    var valueAxis = function (gridIndex, name) {
      return { type: "value", gridIndex: gridIndex, name: name,
        nameTextStyle: { color: muted, fontSize: 11, align: gridIndex ? "center" : "right" },
        axisLabel: { color: muted, fontSize: 11 }, splitLine: { lineStyle: { color: border } } };
    };

    return {
      backgroundColor: "transparent",
      graphic: [{ type: "text", right: 8, top: 30,
        style: { text: "All sessions together", fill: strong, font: "600 11px IBM Plex Sans", align: "right", lineHeight: 14 } }],
      textStyle: { fontFamily: "IBM Plex Sans", color: text },
      animationDuration: 400,
      aria: { enabled: true, label: { description: $("oc-desc").textContent } },
      legend: { data: outcomes, top: 0, left: 0, selectedMode: false, icon: "rect",
        itemWidth: 12, itemHeight: 12, itemGap: 18, textStyle: { color: text, fontSize: 12 } },
      grid: [
        { left: 44, right: "25%", top: 60, bottom: 100 },
        { left: "80%", right: 8, top: 60, bottom: 100, show: true, backgroundColor: raised, borderWidth: 0 }
      ],
      tooltip: {
        trigger: "axis", axisPointer: { type: "shadow", shadowStyle: { color: raised, opacity: 0.6 } },
        backgroundColor: css("--surface"), borderColor: css("--border-firm"), textStyle: { color: text, fontSize: 12 },
        formatter: function (items) {
          var panel = items[0].axisIndex === 2 ? 1 : 0;
          var sl = slots[panel][items[0].dataIndex];
          if (!sl) return "";
          var b = bills(sl);
          var h = '<div style="font-weight:600;color:' + strong + '">' + esc(sessName(sl.s)) + " · " + esc(D.typeNames[sl.t][1]) + "</div>";
          if (b === 0) return h + '<div style="color:' + muted + '">None introduced</div>';
          h += '<div style="color:' + muted + ';margin-bottom:4px">' + b + " bill" + (b === 1 ? "" : "s") + " introduced</div>";
          outcomes.forEach(function (o) {
            var r = line(view, sw, sl.s, sl.t, o);
            if (r.n === 0) return;
            h += '<div style="display:flex;gap:8px;align-items:center;justify-content:space-between;min-width:240px">' +
                 '<span><span style="display:inline-block;width:10px;height:10px;background:' + colour(o) + ';margin-right:6px"></span>' + esc(o) + "</span>" +
                 '<span style="font-variant-numeric:tabular-nums">' + r.n + ' <span style="color:' + muted + '">(' + (r.p === 0 ? "&lt;1" : r.p) + "%)</span></span></div>";
            if (o === "Passed" && r.acts !== null && r.acts < r.n) {
              var x = r.n - r.acts;
              h += '<div style="color:' + muted + ';padding-left:16px;max-width:260px;white-space:normal">' + r.acts +
                   " became Acts; " + x + " passed and " + (x === 1 ? "was" : "were") + " stopped before Royal Assent (M5)</div>";
            }
          });
          return h;
        }
      },
      xAxis: [
        typeAxis(0, 0), groupAxis(D.sessions.map(function (x) { return "Session " + x[0] + "\n" + x[1]; }), 0),
        typeAxis(1, 1), groupAxis(["All sessions\n1999 to date"], 1)
      ],
      yAxis: [valueAxis(0, "Bills"), valueAxis(1, "Bills, own scale")],
      series: series
    };
  }

  // Clicking a part of a bar opens the bills it counts.
  function clicked(p) {
    var c = choices(), outcomes = D.outcomes[c.view], per = outcomes.length + 1;
    var panel = p.seriesIndex >= per ? 1 : 0, i = p.seriesIndex % per;
    if (i === outcomes.length) return;
    var sl = slotsFor(c.sw)[panel][p.dataIndex];
    if (!sl) return;
    location.href = figureAddress(c.view, c.sw, sl.s, sl.t, outcomes[i]);
  }

  // The numbers beneath: every figure the chart is showing, for the choices
  // made, each opening its bills.
  function table() {
    var c = choices(), view = c.view, sw = c.sw, outcomes = D.outcomes[view];
    var cellFor = function (n, href, pct) {
      return '<td class="fig"><a href="' + esc(href) + '">' + n + (pct === undefined ? "" :
             '<span class="pct">(' + (pct === 0 ? "&lt;1" : pct) + "%)</span>") + "</a></td>";
    };
    var h = "<thead><tr><th>Session</th><th>Type</th><th>Bills</th>" + outcomes.map(function (o) {
      return '<th><span class="chip" style="background:' + colour(o) + '"></span>' + esc(o) + "</th>" +
             (o === "Passed" ? "<th>of which became Acts</th>" : "");
    }).join("") + "</tr></thead><tbody>";
    D.sessions.map(function (x) { return x[0]; }).concat(["All sessions"]).forEach(function (s) {
      D.types[sw].forEach(function (t) {
        var bt = line(view, sw, s, t, outcomes[0]).bt;
        h += '<tr class="' + (s === "All sessions" ? "total" : "") + '"><td class="sess"><b>' + esc(sessName(s)) +
             '</b></td><td style="text-align:left">' + esc(D.typeNames[t][1]) + "</td>";
        h += bt ? cellFor(bt, figureAddress(view, sw, s, t)) : '<td class="zero">–</td>';
        outcomes.forEach(function (o) {
          var r = line(view, sw, s, t, o);
          if (!bt) h += '<td class="zero">–</td>';
          else if (!r.n) h += '<td class="zero">0</td>';
          else h += cellFor(r.n, figureAddress(view, sw, s, t, o), r.p);
          if (o === "Passed") {
            if (!bt) h += '<td class="zero">–</td>';
            else if (!r.acts) h += '<td class="zero">0</td>';
            else h += cellFor(r.acts, figureAddress(view, sw, s, t, o, true));
          }
        });
        h += "</tr>";
      });
    });
    $("oc-table").innerHTML = h + "</tbody>";
  }

  function render() {
    if (!chart) {
      chart = echarts.init($("oc-chart"), null, { renderer: "svg" });
      chart.on("click", clicked);
    }
    chart.setOption(build(), true);
    table();
  }
  $("oc-outcomes").addEventListener("change", render);
  $("oc-forth").addEventListener("change", render);
  window.addEventListener("resize", function () { if (chart) chart.resize(); });
  // Redrawn when the reader changes between dark and light.
  new MutationObserver(render).observe(root, { attributes: true, attributeFilter: ["data-mode"] });

  // ---- The tabs, each with its own address, as on the Data page -------------
  var panels = Array.prototype.map.call(document.querySelectorAll("#insight-tabs a"), function (a) {
    return a.getAttribute("data-tab");
  });
  function route() {
    var h = location.hash.slice(1);
    if (!/^[A-Za-z0-9_-]{1,80}$/.test(h)) h = "";
    var target = h && $(h);
    var inPanel = target && target.closest(".panel");
    var panel = panels.indexOf(h) >= 0 ? h : (inPanel ? inPanel.id : panels[0]);
    panels.forEach(function (p) { $(p).hidden = p !== panel; });
    document.querySelectorAll("#insight-tabs a").forEach(function (a) {
      if (a.getAttribute("data-tab") === panel) a.setAttribute("aria-current", "page");
      else a.removeAttribute("aria-current");
    });
    requestAnimationFrame(function () {
      if (chart) chart.resize();
      if (target && panels.indexOf(h) < 0) target.scrollIntoView();
    });
  }
  window.addEventListener("hashchange", route);
  render();
  route();
})();
