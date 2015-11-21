import React from "react";
import _ from "lodash";
import Modal from "react_components/modal";

const ExpireButton = (props) => {
  if(props.link.canExpire) {
    return(
      <i className="icon-remove" onClick={props.onClick}/>
    );
  }
  else {
    return(<div></div>);
  }
}

const SecretEditLinkTable = (props) => (
  <table className="table">
    <thead>
      <tr>
        <th>Recipient</th>
        <th>Creator</th>
        <th>Created At</th>
        <th>Last Used</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <GenerateButton {...props.generateButton}/>
      {
        props.links.map((link, index) => (
          <tr key={link.id}>
            <td>{link.recipient}</td>
            <td>{link.creator}</td>
            <td>{link.created_at}</td>
            <td>{link.last_used}</td>
            <td><ExpireButton link={link} onClick={props.expireLink.bind(null, link.id)}/></td>
          </tr>
        ))
      }
    </tbody>
  </table>
)

const GenerateButton = React.createClass({
  generateLink() {
    if(this.refs.recipient.value.length > 0){
      this.props.addLink(this.refs.recipient.value);
    }
    else {
      alert("Recipient must be present");
    }
  },
  onKeyPress(e) {
    if(e.keyCode === 13) {
      this.generateLink();
    }
  },
  onGenerateClick() {
    this.generateLink();
  },
  render() {
    if(this.props.canEdit) {
      return(
        <tr>
          <td style={{backgroundColor: "#F3F8FC"}}>
            <input
              style={{margin: "5px 0px"}}
              placeholder="Email"
              ref="recipient"
              onChange={this.props.onUpdateRecipient}
              onKeyUp={this.onKeyPress}
              value={this.props.recipient}>
            </input>
          </td>
          <td style={{backgroundColor: "#F3F8FC"}}>{this.props.currentUserName}</td>
          <td style={{backgroundColor: "#F3F8FC"}}></td>
          <td style={{backgroundColor: "#F3F8FC"}}></td>
          <td style={{backgroundColor: "#F3F8FC"}}>
            <i
              className="icon-plus"
              onClick={this.onGenerateClick}
            />
          </td>
        </tr>
      );
    }
    else {
      return <tr></tr>;
    }
  }
});

const margins = { marginBottom: "10px" }
const ViewModalContents = (viewModalProps) => (
  <div>
    <h4 style={margins}>Secret Edit Link Created!</h4>
    <div style={margins}>{ `Your secret edit link for ${viewModalProps.link.recipient} is:` }</div>
    <div style={_.assign({fontWeight: "bold"}, margins)}>{ viewModalProps.link.link }</div>
    <div style={margins}>Please copy and email the link now, since it will not be visible after this dialogue is closed.</div>
    <div className="btn btn-primary" onClick={viewModalProps.close}>Done</div>
  </div>
)

const ViewLinkModal = (viewModalProps) => (
  <Modal isVisible={viewModalProps.isVisible} renderContents={ViewModalContents.bind(null, viewModalProps)}/>
)

const CancelModalContents = (props) => (
  <div>
    <h4 style={margins}>Cancel Secret Edit Link</h4>
    <div style={{marginBottom: "20px"}}>Are you sure you want to cancel this secret edit link?</div>
    <div className="btn btn-primary" style={{marginRight: "5px"}} onClick={props.continue}>Yes</div>
    <div className="btn btn-default" onClick={props.abort}>No</div>
  </div>
)

const CancelModal = (props) => (
  <Modal
    isVisible={props.isVisible}
    renderContents={CancelModalContents.bind(null, props)}
  />
)

const SecretEditLinks = React.createClass({
  getInitialState() {
    return {};
  },
  links() {
    return (this.state.links || this.props.links);
  },
  addLink(recipient) {
    $.post(this.props.addLink, {
      recipient: recipient,
      accessible_id: this.props.accessibleId,
      accessible_type: this.props.accessibleType
    }).done((data) => {
      this.setState({
        links: [ data.link ].concat(this.links()),
        viewModal: { isVisible: true, link: data.link },
        recipient: ""
      });
    })
  },
  viewModalProps() {
    return _.assign(
      {},
      (this.state.viewModal || this.props.viewModal),
      { close: this.closeViewModal }
    );
  },
  closeViewModal() {
    this.setState({viewModal: { isVisible: false }});;
  },
  onUpdateRecipient: function(e) {
    this.setState({ recipient: e.target.value });
  },
  expireLink: function(id) {
    this.setState({
      cancelModal: { isVisible: true, idToCancel: id }
    });
  },
  continueCancel() {
    $.ajax({
      url: `/secret_tokens/${this.state.cancelModal.idToCancel}`,
      type: "DELETE"
    }).done((data) => {
      this.setState({
        links: _.filter(this.links(), (link) => link.id !== this.state.cancelModal.idToCancel),
        cancelModal: { isVisible: false, idToCancel: null }
      });
    })
  },
  abortCancel() {
    this.setState({
      cancelModal: { isVisible: false, idToCancel: null }
    })
  },
  recipient() {
    return (this.state.recipient || "");
  },
  cancelModalProps() {
    return _.assign(
      {},
      (this.state.cancelModal || { isVisible: false, idToCancel: null }),
      {
        continue: this.continueCancel,
        abort: this.abortCancel
      }
    );
  },
  generateButtonProps() {
    return({
      canEdit: this.props.canEdit,
      addLink: this.addLink,
      recipient: this.recipient(),
      currentUserName: this.props.currentUserName,
      onUpdateRecipient: this.onUpdateRecipient
    });
  },
  render() {
    return(
      <div style={{marginTop: "10px"}}>
        <h6 style={{marginBottom: "5px"}}>Secret Edit Links</h6>
        <i style={{marginLeft: "5px"}}>Anyone can edit the record if they have one of the following links:</i>
        <SecretEditLinkTable
          links={this.links()}
          expireLink={this.expireLink}
          generateButton={this.generateButtonProps()}
        />
        <ViewLinkModal {...this.viewModalProps()}/>
        <CancelModal {...this.cancelModalProps()}/>
      </div>
    );
  }
});

export default SecretEditLinks;