import React, { Component } from 'react'
import { connect } from 'react-redux'
import { List, InputItem, Switch, Stepper, Range, Button } from 'antd-mobile';
const {Item} = List
class ShoppingCart extends Component {
  render() {
    return ((<form>
      <List
        renderHeader={() => 'Form Validation'}
      >
        <Item extra={<Stepper style={{ width: '100%', minWidth: '100px' }} showNumber size="small" defaultValue={20} />}>Number of Subscribers</Item>
      </List>
    </form>)
    )
  }
}

const mapStateToProps = (state) => ({
  
})

const mapDispatchToProps = {
  
}

export default connect(mapStateToProps, mapDispatchToProps)(ShoppingCart)
