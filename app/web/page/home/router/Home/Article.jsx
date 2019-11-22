import React, { Component } from 'react'
import { connect } from 'react-redux'

class Article extends Component {
  render() {
    return (
      <div>
        小知识
      </div>
    )
  }
}

const mapStateToProps = (state) => ({
  
})

const mapDispatchToProps = {
  
}

export default connect(mapStateToProps, mapDispatchToProps)(Article)
