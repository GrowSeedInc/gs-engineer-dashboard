/* eslint-disable */
import type { DefineMethods } from 'aspida';
import type * as Types from '../../../../../@types';

export type Methods = DefineMethods<{
  post: {
    status: 200;

    /** ユーザー切り替え成功 */
    resBody: {
      /** JWTトークン */
      token: string;
      user: Types.User;
    };

    reqBody: {
      user_id: number;
    };
  };
}>;
