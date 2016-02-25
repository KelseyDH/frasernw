var PANEL_REDUCERS = {
  FilterTable: require("../filter_table"),
  InlineArticles: function(state, action) { return state }
}
import hasBeenInitialized from "../has_been_initialized";
import pageRenderedKey from "reducers/page_rendered_key";
import feedbackModal from "reducers/feedback_modal";

var procedureId = _.partial(pageRenderedKey, "procedureId");
var specializationId = _.partial(pageRenderedKey, "specializationId");
var pageType = _.partial(pageRenderedKey, "pageType");


module.exports = function(state = {}, action) {
  switch(action.type) {
  default:
    return {
      hasBeenInitialized: hasBeenInitialized(state.hasBeenInitialized, action),
      selectedPanel: selectedPanel(state.selectedPanel, action),
      specializationId: specializationId(state.specializationId, action),
      procedureId: procedureId(state.procedureId, action),
      pageType: pageType(state.pageType, action),
      panels: panels(state.panels, action),
      feedbackModal: feedbackModal(state.feedbackModal, action),
      anchor: anchor(state.anchor, action)
    }
  }
}

var anchor = (state, action) => {
  switch(action.type){
  case "READ_ANCHOR":
    return action.anchor;
  default:
    return state
  }
}

// (tabs e.g. 'specialists', 'clinics', 'physician resources')
var panels = function(state = {}, action) {
  if (action.panelKey) {
    var reducer = PANEL_REDUCERS[action.reducer];

    return _.assign(
      {},
      state,
      { [action.panelKey]: reducer(state[action.panelKey], action) }
    );
  } else {
    return state;
  };
}

var selectedPanel = function(state, action) {
  switch(action.type) {
  case "SELECT_PANEL":
    return action.panel;
  default:
    return state;
  }
}
