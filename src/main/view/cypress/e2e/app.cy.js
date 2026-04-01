describe('App E2E', () => {
  beforeEach(() => {
    cy.visit('/')
  })

  it('메인 페이지가 정상적으로 로드된다', () => {
    cy.get('.App-header').should('be.visible')
  })

  it('헤더 콘텐츠가 표시된다', () => {
    cy.contains('ssssss').should('be.visible')
  })
})
