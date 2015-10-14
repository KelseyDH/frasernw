var React = require("react");

module.exports = React.createClass({
  render: function() {
    return(
      <div id="icon_key">
        <div className="title">Icon Key</div>
        <ul className="no-marker">
          <li>
            <i className="icon-ok icon-green"/>
            <span>Accepting New referrals</span>
          </li>
          <li>
            <i className="icon-remove icon-red"/>
            <span>Not accepting new referrals</span>
          </li>
          <li>
            <i className="icon-question-sign icon-text"/>
            <span>Referral status is unknown</span>
          </li>
        </ul>
      </div>
    );
  }
});