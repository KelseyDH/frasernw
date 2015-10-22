var React = require("react");

module.exports = React.createClass({
  propTypes: {
    id: React.PropTypes.number,
    itemType: React.PropTypes.string,
    title: React.PropTypes.string,
    state: React.PropTypes.string
  },
  handleSubmit: function(e){
    e.preventDefault();

    var comment = React.findDOMNode(this.refs.feedback).value.trim()

    if(!comment){
      return;
    } else {
      $.post("/feedback_items", {
        feedback_item: {
          item_id: this.props.id,
          item_type: this.props.itemType,
          feedback: comment
        }
      }).success(() => {
        this.props.dispatch({
          type: "SUBMITTED_FEEDBACK"
        });
      })

      this.props.dispatch({
        type: "SUBMITTING_FEEDBACK"
      });
    }
  },
  handleClose: function(e){
    e.preventDefault();
    this.props.dispatch({
      type: "CLOSE_FEEDBACK_MODAL"
    });
  },
  modalStyle: {
    position: "fixed",
    top: "25%",
    left: "25%",
    width: "50%",
    backgroundColor: "white",
    padding: "30px",
    boxShadow: "2px 2px 8px #888"
  },
  submitText: function() {
    if (this.props.state === "SUBMITTING"){
      return "Submitting";
    } else {
      return "Submit";
    }
  },
  form: function() {
    return(
      <div style={this.modalStyle}>
        <div className="inner">
          <form onSubmit={this.handleSubmit}>
            <label style={{fontWeight: "bold"}}>
              <span>Please provide us with any comments about </span>
              <span className="feedback_item_title">{ this.props.title }</span>
              <textarea
                ref="feedback"
                style={{width: "100%", height: "150px", marginTop: "10px"}}
              ></textarea>
            </label>
            <div className="form-actions">
              <input type="submit" className="btn btn-primary" value={ this.submitText() }/>
              <a className="btn btn-danger"
                onClick={this.handleClose}
                style={{marginLeft: "2px"}}
              >Cancel</a>
            </div>
          </form>
        </div>
      </div>
    );
  },
  postSubmit: function() {
    return(
      <div style={this.modalStyle}>
        <div className="inner">
          <h2>Thank you!</h2>
          <p className="space no_indent">
            <span>Thank you for providing your feedback on </span>
            <span>{ this.props.title }</span>
            <span> .Your contributions help make Pathways a valuable resource for the community.</span>
          </p>
          <p className="space no_indent">We will review your feedback in the near future and take action as necessary</p>
          <a className="btn btn-primary"
            onClick={this.handleClose}
            style={{marginTop: "10px"}}>Close</a>
        </div>
      </div>
    )
  },
  render: function(){
    if(this.props.state === "PRE_SUBMIT" || this.props.state === "SUBMITTING"){
      return this.form();
    } else if (this.props.state === "POST_SUBMIT") {
      return this.postSubmit();
    } else {
      return null;
    }
  }
})
