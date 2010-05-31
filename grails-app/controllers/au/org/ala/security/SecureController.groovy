package au.org.ala.security

/**
 * For testing security only
 */
class SecureController {
   def index = {
      render 'Secure access only'
   }
}