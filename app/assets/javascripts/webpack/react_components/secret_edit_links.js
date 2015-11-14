import React from "react";
import _ from "lodash";
import Modal from "react_components/modal";

const ExpireIcon = (props) => {
  if(props.link.canExpire) {
    return(<i className="icon-remove" onClick={props.onClick}/>);
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
        <th></th>
      </tr>
    </thead>
    <tbody>
      {
        props.links.map((link, index) => (
          <tr key={link.id}>
            <td>{link.recipient}</td>
            <td>{link.creator}</td>
            <td>{link.created_at}</td>
            <td><ExpireIcon link={link} onClick={props.expireLink.bind(null, link.id)}/></td>
          </tr>
        ))
      }
    </tbody>
  </table>
)

const GenerateButton = React.createClass({
  onGenerateClick() {
    if(this.refs.recipient.value.length > 0){
      this.props.addLink(this.refs.recipient.value);
    }
    else {
      alert("Recipient must be present");
    }
  },
  render() {
    if(this.props.canEdit) {
      return(
        <div>
          <hr/>
          <div
            className="btn btn-default"
            onClick={this.onGenerateClick}
          >Generate new link for</div>
          <input
            style={{marginBottom: "0px", marginLeft: "5px"}}
            placeholder="Recipient Email"
            ref="recipient"
            onChange={this.props.onUpdateRecipient}
            value={this.props.recipient}
          ></input>
        </div>
      );
    }
    else {
      return <div></div>;
    }
  }
});

const margins = { marginBottom: "10px" }
const ModalContents = (modalProps) => (
  <div>
    <h4 style={margins}>Secret Edit Link Created!</h4>
    <div style={margins}>{ `Your secret edit link for ${modalProps.link.recipient} is:` }</div>
    <div style={_.assign({fontWeight: "bold"}, margins)}>{ modalProps.link.link }</div>
    <div style={margins}>This link will not be visible after this notification is closed, in order to preserve knowledge of its creator and recipients.</div>
    <div className="btn btn-primary" onClick={modalProps.close}>Done</div>
  </div>
)

const SecretEditModal = (modalProps) => (
  <Modal isVisible={modalProps.isVisible} renderContents={ModalContents.bind(null, modalProps)}/>
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
        modal: { isVisible: true, link: data.link },
        recipient: ""
      });
    })
  },
  modalProps() {
    return _.assign(
      {},
      (this.state.modal || this.props.modal),
      { close: this.closeModal }
    );
  },
  closeModal() {
    this.setState({modal: { isVisible: false }});;
  },
  onUpdateRecipient: function(e) {
    this.setState({ recipient: e.target.value });
  },
  expireLink: function(id) {
    if(confirm("Are you sure you would like to expire this secret edit link?")){
      $.ajax({
        url: `/secret_tokens/${id}`,
        type: "DELETE"
      }).done((data) => {
        this.setState({
          links: _.filter(this.state.links, (link) => link.id !== id)
        });
      })
    }
  },
  recipient() {
    return (this.state.recipient || "");
  },
  render() {
    return(
      <div style={{marginTop: "10px"}}>
        <h6 style={{margin: "0px", marginBottom: "5px"}}>Secret Edit Links</h6>
        <i style={{marginLeft: "5px"}}>Anyone can edit the record if they have one of the following links:</i>
        <SecretEditLinkTable links={this.links()} expireLink={this.expireLink}/>
        <GenerateButton
          canEdit={this.props.canEdit}
          addLink={this.addLink}
          recipient={this.recipient()}
          onUpdateRecipient={this.onUpdateRecipient}
        />
        <SecretEditModal {...this.modalProps()}/>
      </div>
    );
  }
});

export default SecretEditLinks;
